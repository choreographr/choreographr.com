+++
title = "The Solution"
description = ""
date = 2021-05-01T19:30:00+00:00
updated = 2021-05-01T19:30:00+00:00
draft = false
weight = 20
template = "content-doc.html"

+++

<img src="/acuity-index.svg" style="width: 100%; height: auto;"></img>

One solution is for the user to run their own full node for each chain that is being queried, but this is almost never practical. Running a full node typically requires terabytes of storage & bandwidth and can take weeks to become fully synchronized.

Dapps can query full nodes and use a light client to cryptographically verify the results are correct. In fact, [Ethereum](https://www.youtube.com/watch?v=ZHNrAXf3RDE) and [Substrate](https://www.youtube.com/watch?v=xzC9KJXtidE) are both introducing improvements to their light client technology. This solves the problem of incorrect data.

However, this does not solve all the other problems.

An Acuity Index node runs alongside the Substrate node it is indexing. In its simplest implementation it maintains an index of block number and event index for each key, for example account id.

## High performance

Acuity Index uses the [Sled](http://sled.rs/) key value database to create an event index that can handle very large query throughput. It is considerably more efficient than EVM indexed topics.

Clients can request to either receive just the block number and event index of each event, or also receive the event data.

Event data can then be verified as correct using the underlying light client of the chain.

For maximum performance, the index can store the event data. Alternatively, it can retrieve this from the full node as required to save space.

## Well-defined query accounting

An index node can track cumulative query weight, either by authenticated account, or by virtual account (ip address).

## Standardized API

Because index nodes for a given chain have an identical API, it makes it very easy for a dapp to switch between different indexes based on availablity, performance, price, etc.

## Privacy

If the user is accessing an index node for free, they will need to make a direct connection to the index so it can monitor and limit use based on IP address. This is not good for privacy.

If the user is paying for their queries, then they can also obfuscate their identity by querying via tor or mixnet and paying via anonymous means.

## Extensible

Chain indexes can extend indexing beyond events. For example, IPFS full-text search, AI content classification, geospatial search, etc.
