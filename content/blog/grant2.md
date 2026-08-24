+++
title = "Web3 Foundation Grant 2 Completed"
description = "The final milestone of the second Web3 Foundation grant for Hybrid Indexer has now been completed and submitted for evaluation."
date = 2024-03-12
draft = false
template = "blog-page.html"

[taxonomies]
authors = ["Jonathan Brown"]

+++

The final milestone of the [second](https://github.com/w3f/Grants-Program/blob/master/applications/hybrid2.md) Web3 Foundation grant for Hybrid Indexer has now been completed and submitted for evaluation.
The following deliverables have been completed:

## Milestone 1 - Indexer Improvements

### 1.1 Combine head and batch indexer threads

Previously there were separate threads for indexing new head blocks. These have now been combined into a single thread to simplify the codebase.

### 1.2 Check correct chain

The indexer now ensures that both the chain being indexed and the existing index database have the correct genesis block.

### 1.3 Improved logging

Verbosity level can now be controlled by command line parameter. Statistics are output with a regular time interval, not block interval.

### 1.4 Improved error checking

All error conditions in the codebase are now handled correctly. Exiting is handled gracefully.

## Milestone 2 — Reverse Batch Indexing

### 2.1 Index backwards

When the indexer starts it batch indexes backwards from head.

### 2.2 Store indexed spans

The indexer stores in the database a record of which spans of blocks have been indexed with which version of the indexer and utilizes this information to avoid redundantly indexing blocks multiple times.

### 2.3 Declare indexer start blocks

Each chain indexer can declare which block each version of the indexer should start from. Blocks are automatically re-indexed after upgrading the indexer.

## Milestone 3 — Database Improvements

### 3.1 Support additional indexes

Chain indexers can define additional index parameter types that can be indexed.

### 3.2 Variant index optional

Event variant is the largest index because every event is indexed. Indexing event variant is now optional.

### 3.3 Expose cache_capacity() and mode()

These database parameters are now exposed on the command line.

## Milestone 4 — WebSocket API Improvements

### 4.1 Status subscription

It is now possible to subscribe to status updates.

### 4.2 Unsubscribing

It is now possible to unsubscribe from status updates and event parameter watching.

### 4.3 Report each index size

It is now possible to get a report of how much storage space is used by each index.

### 4.4 Rust API

A [Rust library](https://github.com/hybrid-explorer/hybrid-api-rs/) has been developed to make it easier for Rust applications to query Hybrid indexes.

## Additional Changes

* [subxt](https://github.com/paritytech/subxt) has been upgraded to 0.34
* logging is now performed by the `tracing` crate rather than `log`
* [polkadot-indexer](https://github.com/hybrid-explorer/polkadot-indexer/) has been updated to the latest metadata.
* [hybrid-cli](https://github.com/hybrid-explorer/hybrid-cli) has been created enabling querying of Hybrid indexes from the command line using hybrid-api-rs
* head indexing no longer interrupts batch indexing
* sporadic lockups while downloading metadata no longer occurs
