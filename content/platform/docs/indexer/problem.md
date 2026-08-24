+++
title = "The Problem"
description = ""
date = 2021-05-01T19:30:00+00:00
updated = 2021-05-01T19:30:00+00:00
draft = false
weight = 10
template = "platform-doc.html"

+++

Dapps need to write to and query blockchain state, events (logs) and decentralized filesystems such as [IPFS](https://ipfs.tech/). Current state can be read and modified on-chain by extrinsics (transactions). Historic state can only be read off-chain. Events can be written by extrinsics, but only read off-chain. Files on IPFS can only be written and read off-chain, but a cryptographic hash of the file can be stored on-chain in state or an event.

|               | Read         | Write     | Modify   | 
|---------------|--------------|-----------|----------|
|Current State  | on/off-chain | on-chain  | on-chain |
|Historic State | off-chain    |           |          |
|Events         | off-chain    | on-chain  |          |
|IPFS           | off-chain    | off-chain |          |

Writing data to an event is considerably cheaper than writing it to state. IPFS is free, except for storage and bandwidth costs to keep a file [pinned](https://docs.ipfs.tech/how-to/pin-files/).

For example, the balance of an address must be stored in state. This is necessary so that it can be checked that an account has enough balance for a transfer. The record of balance transfers is stored in events to reduce transaction fees. A user's public avatar and blog posts would be stored on IPFS with only the hashes stored in events.

Dapps need to be able to search decentralized data. For example, a wallet dapp needs to be able to find every balance transfer event either from or to the user's address. A map dapp needs to perform geospatial search on GPS coordinates stored in events. A feed reader dapp needs to be able to perform full-text search stored on IPFS.

Currently, Polkadot dapps will typically query a centralized RPC provider to read the state and broadcast transactions.

This arrangement has a number of issues that undermines the decentralized nature of dapps:

## Incorrect or missing data

The dapp typically trusts the RPC provider to return correct query results. In theory, the results may be incorrect or incomplete. This could be used to trick the user into doing something self-harming.

## Event query limits

Polkadot RPCs do not provide any event searching facility. EVM RPC providers do, but typically have various query limits (especially free ones):

* max blocks scanned per query
* earliest scannable block
* max execution time
* event searching disabled completely

Additionally, there is no API for a dapp to query what an EVM RPC provider's limits are. If a dapp exceeds limits it will receive a non-semantic error message that can only be presented to the user. This makes for an unacceptable user experience.

## Slow queries

The event indexing built into Ethereum uses a form of accelerated scanning using bloom filters. This is considerably slower to query than a real database index and uses more resources.

The provider may take a long time to respond to a query, giving the user a poor experience.

## Unavailability

There are various reasons why an RPC provider may not provide query results to a dapp:

* technical problems - 100% uptime is impossible for a centralized service
* geoblocking - social and political pressure can result in queries from certain physical locations being blocked
* KYC requirements - the provider may be required by law to obtain the real-world identity of the user of the dapp
* lack of payment

## No standard payment API

There are various services that offer paid access to high quality nodes, but there is no standard for how to pay for them. This creates a lot of friction for users that want to query multiple chains and switch between different providers.

## Tracking

The provider could be logging data of which IP addresses and real-world identities are making which queries. 

## Encourages dapp backends

A very attractive solution to the issues with RPC providers is for dapp developers to build a centralized backend that will do everything required in a very efficient way. Unfortunately, this undermines many of the advantages of having a dapp.

## More expensive transactions

Because searching for logs is unreliable, architects of smart contracts and Substrate pallets may decide to store data in state where it can be more easily retrieved. This is considerably more expensive. The additional use of block-space will also make all other transactions on the chain more expensive.

## Lack of extensibility

Chains may need to have deeper indexing beyond events. For example, they may wish to have full text search on IPFS content linked from the chain.
