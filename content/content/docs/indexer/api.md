+++
title = "WebSocket API"
description = ""
date = 2021-05-01T19:30:00+00:00
updated = 2021-05-01T19:30:00+00:00
draft = false
weight = 80
template = "content-doc.html"

+++

The public API is a JSON-over-WebSocket protocol exposed on `ws://localhost:8172`
by default.

There are two message classes:

- request/response messages, which always carry an `id`
- notifications, which never carry an `id`

## Requests

Every request includes:

- `id`: client-selected unsigned integer
- `type`: request discriminator

Example:

```json
{"id":1,"type":"Status"}
```

## Responses

Every successful or failed request receives a response with the same `id`.

Example:

```json
{
  "id": 1,
  "type": "status",
  "data": []
}
```

## Main Request Types

- `Status`: returns indexed block spans
- `Variants`: returns pallet and event variant metadata
- `GetEvents`: queries indexed events for a key, optionally paginated with `before`
  and optionally enriched with finalized proofs via `includeProofs`
- `SubscribeStatus`: subscribes to status changes
- `SubscribeEvents`: subscribes to updates for one key
- `UnsubscribeStatus`: removes a status subscription
- `UnsubscribeEvents`: removes an event subscription
- `SizeOnDisk`: returns current database size

## `Status`

Request:

```json
{"id":1,"type":"Status"}
```

Response type: `status`

Response payload:

- array of indexed block spans
- each span has `start` and `end`

Example:

```json
{
  "id": 1,
  "type": "status",
  "data": [
    {"start": 1, "end": 1000}
  ]
}
```

## `Variants`

Request:

```json
{"id":2,"type":"Variants"}
```

Response type: `variants`

Response payload:

- array of pallets
- each pallet has `index`, `name`, and `events`
- each event variant has `index` and `name`

Example:

```json
{
  "id": 2,
  "type": "variants",
  "data": [
    {
      "index": 42,
      "name": "Referenda",
      "events": [
        {"index": 0, "name": "Submitted"}
      ]
    }
  ]
}
```

## Example `GetEvents`

```json
{
  "id": 3,
  "type": "GetEvents",
  "key": {
    "type": "Custom",
    "value": {"name": "ref_index", "kind": "u32", "value": 42}
  },
  "limit": 100,
  "before": null,
  "includeProofs": false
}
```

Request fields:

- `key`: query key
- `limit`: optional `u16`, default `100`
- `before`: optional event cursor
- `includeProofs`: optional boolean, default `false`

Response type: `events`

Response payload:

- `key`: the queried key
- `events`: matching event refs, newest first
- `decodedEvents`: decoded payloads when event storage is enabled
- `proofsByBlock`: omitted unless proofs were requested; `null` if requested but unavailable
- `proofsStatus`: omitted unless proofs were requested

Proofs are only returned while the indexer is running in finalized mode. When
available, the response includes one proof object per returned block containing
the finalized block hash, header, `System.Events` storage key/value pair, and the
storage proof for that value.

Each `EventRef` contains:

- `blockNumber`
- `eventIndex`

Each decoded event object contains:

- `specVersion`
- `palletName`
- `eventName`
- `palletIndex`
- `variantIndex`
- `eventIndex`
- `fields`

Each proof object contains:

- `blockNumber`
- `blockHash`
- `header`
- `storageKey`
- `storageValue`
- `storageProof`

`proofsStatus` contains:

- `available`
- `reason`
- `message`

Example response:

```json
{
  "id": 3,
  "type": "events",
  "data": {
    "key": {"type": "Custom", "value": {"name": "ref_index", "kind": "u32", "value": 42}},
    "events": [
      {"blockNumber": 50, "eventIndex": 3}
    ],
    "decodedEvents": [
      {
        "blockNumber": 50,
        "eventIndex": 3,
        "event": {
          "specVersion": 1234,
          "palletName": "Referenda",
          "eventName": "Submitted",
          "palletIndex": 42,
          "variantIndex": 0,
          "eventIndex": 3,
          "fields": {
            "index": 42
          }
        }
      }
    ],
    "proofsByBlock": [
      {
        "blockNumber": 50,
        "blockHash": "0xabc123...",
        "header": {
          "parent_hash": "0x...",
          "number": 50,
          "state_root": "0x...",
          "extrinsics_root": "0x...",
          "digest": {"logs": []}
        },
        "storageKey": "0x26aa394eea5630e07c48ae0c9558cef780d41e5e16056765bc8461851072c9d7",
        "storageValue": "0x...",
        "storageProof": ["0x..."]
      }
    ],
    "proofsStatus": {
      "available": true,
      "reason": "included",
      "message": "Finalized event proofs included."
    }
  }
}
```

If proofs were requested while the indexer is not running in finalized mode,
`proofsByBlock` is returned as `null` and `proofsStatus.reason` is
`finalized_proofs_unavailable`.

## Composite Custom Keys

Composite keys use an ordered array of typed values:

```json
{
  "id": 3,
  "type": "GetEvents",
  "key": {
    "type": "Custom",
    "value": {
      "name": "item_revision",
      "kind": "composite",
      "value": [
        {"kind": "bytes32", "value": "0xabc123..."},
        {"kind": "u32", "value": 7}
      ]
    }
  }
}
```
