+++
title = "Acuity Index 0.7.0 Released"
description = "This release of Acuity Index was funded by the Kusama Treasury."
date = 2025-07-24
draft = false
template = "blog-page.html"

[taxonomies]
authors = ["Jonathan Brown"]

+++

This release of Acuity Index was [funded](https://kusama.polkassembly.io/referenda/534) by the Kusama Treasury.

Acuity Index is an event indexer for Polkadot blockchains. Its primary purpose is to enable the creation of true decentralized applications (dapps). Typically dapps are either fully decentralized and have an extremely limited user interface, or are hard coded to a centralized backend and have a rich user interface.

An Acuity Index runs alongside a full node and provides a standardized API for dapps to be able to search and subscribe to events based on various keys, for example `AccountId`.

## Update to Polkadot SDK polkadot-stable2503

[acuity-index-substrate](https://github.com/acuity-network/acuity-index-substrate) and [acuity-index-polkadot](https://github.com/acuity-network/acuity-index-polkadot) have been updated to support the latest pallets and events in `polkadot-stable2503`

Support for the `spend_index` key in the Treasury pallet.

Support for the following Frame pallets:
* Conviction Voting
* Referenda
* Delegated Staking
* State Trie Migration
* Sudo
* Staking
* Recovery

Support for the following Polkadot pallets:
* Para Inclusion
* On Demand

## Update to subxt 0.42.1

[subxt](https://github.com/paritytech/subxt) is a Rust library for communication with Substrate nodes. Acuity Index now uses version 0.42.1

## Serve block events directly

Previously the index search results would only include block number and event index. Dapps would then have to load the blocks from a full node before the events can be processed.

Now the indexer will return `event_bytes` and `spec_version` for all blocks that contain events that match the search terms, enabling dapps to decode the blocks directly and process the events.

In a later version of Acuity Index individual decoded events will be stored and served by the index instead of all the events in a block.

## Make indexing of finalized blocks optional

Previously only "finalized" blocks would be indexed. Now the indexer can be configured to index "best" blocks.
