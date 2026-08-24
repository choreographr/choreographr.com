+++
title = "Standardized, decentralized indexing for Polkadot dapps"
description = "A key issue holding back dapps across all blockchain ecosystems, including Polkadot, is the use of centralized backends."
date = 2025-07-31
draft = false
template = "blog-page.html"

[taxonomies]
authors = ["Jonathan Brown"]

+++

A key issue holding back dapps across all blockchain ecosystems, including Polkadot, is the use of centralized backends. Being able to submit transactions permissionlessly and having autonomous on-chain business logic are key to setting the world free from the archaic systems that currently govern our world, but this is not enough.

For dapps to provide a rich user experience they need to be able to query not just chain state, but an index of what has happened in the past. Maintaining such an index requires significant resources and is therefore inheritantly centralized. For example, decentralized social media needs to be able to query which posts have mentioned a specific user. To prevent reliance on a centralized source of truth, dapps needs to be able to choose which index they wish to use in the same way that they can chose which full node to query. This of course requires standardized APIs for querying the index.

## Acuity Index

Acuity Index enables standardized indexing for Polkadot chains. If a specific index is not working well or is compromised, dapps can simply switch to another.

 Currently it is necessary to build an indexer for each chain using the [acuity-index-substrate](https://crates.io/crates/acuity-index-substrate) Rust library. The next version of Acuity Index will be an omni-indexer. Each chain will be able to simply maintain an index specification config file.

Future features include:
* publishing index specification on-chain
* registering index node on-chain
* private on-chain payment for index access (make money by hosting an index)
* other standardized rich node services such as: IPFS pinning & full text search, private user settings storage, AI queries

## Funding

Acuity Index was originally called Hybrid and was funded by two ([1](https://github.com/w3f/Grants-Program/blob/master/applications/hybrid.md), [2](https://github.com/w3f/Grants-Program/blob/master/applications/hybrid2.md)) Web3 Foundation grants and a Kusama Treasury [referendum](https://kusama.polkassembly.io/referenda/534). A second funding referendum is currently being [voted on](https://kusama.polkassembly.io/referenda/567).

## Example

Build Acuity Index Polkadot:

```
git clone https://github.com/acuity-network/acuity-index-polkadot
cd acuity-index-polkadot
cargo build --release
```

Examine command line parameters:

```
cargo run --release -- --help
```

This outputs the following help page:

```
Usage: acuity-index-polkadot [OPTIONS]

Options:
  -c, --chain <CHAIN>
          Chain to index [default: polkadot] [possible values: polkadot, kusama, westend, paseo]
  -d, --db-path <DB_PATH>
          Database path
      --db-mode <DB_MODE>
          Database mode [default: low-space] [possible values: low-space, high-throughput]
      --db-cache-capacity <DB_CACHE_CAPACITY>
          Maximum size in bytes for the system page cache [default: "1024.00 MiB"]
  -u, --url <URL>
          URL of Substrate node to connect to
      --queue-depth <QUEUE_DEPTH>
          Maximum number of concurrent requests to the chain [default: 1]
  -f, --finalized
          Only index finalized blocks
  -i, --index-variant
          Index event variants
  -s, --store-events
          Store events in index for immediate retrieval
  -p, --port <PORT>
          Port to open for WebSocket queries [default: 8172]
  -v, --verbose...
          Increase logging verbosity
  -q, --quiet...
          Decrease logging verbosity
  -h, --help
          Print help
  -V, --version
          Print version
```

In order to index thousands of blocks per seconds, Acuity Index creates an asynchronous queue of blocks to be retrieved and processed. This means the round-trip latency to retrieve each block can be parallellized. As this can put a huge strain on the full node that is being indexed, `--queue-depth` defaults to 1. For high-speed indexing the index should have a dedicated archive node. Performance increases can be observed up to a depth of around 64.

`--index-variant` will treat the pallet and event type as an additional key to be indexed. For example, the index could be queried for every balance transfer.

`--store-events` will store raw event bytes for each block indexed. These will then be served directly with index results for immediate processing and display to the user. This increases index storage requirements considerably.

Install the commandline query tool:

```
cargo install acuity-index-substrate-cli
```

Query key types that can be queried / subscribed to

```
ais --url ws://0.0.0.0:8172 get-events
```

```
Query for events with a key

Usage: ais --url <URL> get-events <COMMAND>

Commands:
  account-id       AccountId
  account-index    AccountIndex
  bounty-index     BountyIndex
  era-index        EraIndex
  message-id       MessageId
  pool-id          PoolId
  preimage-hash    PreimageHash
  proposal-hash    ProposalHash
  proposal-index   ProposalIndex
  ref-index        RefIndex
  registrar-index  RegistrarIndex
  session-index    SessionIndex
  tip-hash         TipHash
  variant          Variant
  help             Print this message or the help of the given subcommand(s)

Options:
  -h, --help  Print help
```

Query local node for events by Account Id:

```
ais --url ws://0.0.0.0:8172 get-events account-id --key 1tqrqW1qd2D9GG6qt2gtBMP8PYDmkumvLSpYEpdth1xwP1B
```

```
block number: 27072121, event index: 61
block number: 27072121, event index: 60
```

If you would like help indexing a Polkadot blockchain with Acuity Index, please email jbrown@acuity.network
