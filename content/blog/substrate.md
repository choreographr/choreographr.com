+++
title = "Acuity Index Substrate Released"
description = "All blockchain platforms currently have a critical problem that is preventing dapps from being both fully decentralized and performant: dapps cannot search blockchains in a decentralized manner."
date = 2024-05-20
draft = false
template = "blog-page.html"

[taxonomies]
authors = ["Jonathan Brown"]

+++

All blockchain platforms currently have a critical problem that is preventing [dapps](https://en.wikipedia.org/wiki/Decentralized_application) from being both fully decentralized and performant: dapps cannot search blockchains in a decentralized manner.

Ethereum attempted to solve this problem with [event topics](https://docs.soliditylang.org/en/latest/contracts.html#events). Dapps can ask a centralized RPC provider to scan events emitted by smart contracts. This revealed a number of critical issues:

* difficult to find endpoints
* unavailability - the endpoint may not be functioning
* there may be query limits unknownable to the dapp
* the provider may return incorrect results
* light clients do not work in practice
* subscriptions are unreliable
* queries can be very slow, for example when scanning the whole blockchain
* no standardized on-chain payment API
* tracking - providers can invade privacy
* lack of extensibility - no full text or AI search
* adds to gas cost

In fact some startups such as GhostLogs and Shadow are promoting the harmful idea that events should not be emitted on-chain at all, and centralized services should determine the events. This is a non-starter because in order to prove by light client that an event occurred it needs to be emitted by the contract on the blockchain.

[Polkadot SDK](https://polkadot.com/platform/sdk/) has a much simpler approach to events than the EVM. Events are emitted on-chain, but there is no additional transaction weight to indicate that they should be indexed.

Both [Ethereum](https://www.youtube.com/watch?v=ZHNrAXf3RDE) and [Substrate](https://www.youtube.com/watch?v=xzC9KJXtidE) are implementing improvements to their light client protocols so they will actually be useable.

Acuity Index is a decentralized event index for all chain types. It has the following properties:
* a directory of endpoints stored on the Acuity blockchain
* redundancy - multiple endpoints can be queried ensuring no data is omitted
* well-defined query pricing
* both search and regular state queries supported
* results verifiable by light client
* both historic queries and subscriptions supported
* reduced gas cost - smart contracts can issue events without topics
* extensible - search can be extended off-chain, e.g. [IPFS](https://ipfs.tech/)

The first chain type being targeted is Substrate. [Acuity Index Substrate](https://github.com/acuity-network/acuity-index-substrate) is a Rust library that can build an indexer for any Substrate chain. It was originally called Hybrid Indexer and was funded by two grants ([1](https://github.com/w3f/Grants-Program/blob/master/applications/hybrid.md), [2](https://github.com/w3f/Grants-Program/blob/master/applications/hybrid2.md)) from the [Web3 Foundation](https://grants.web3.foundation/).

[Acuity Index Polkadot](https://github.com/acuity-network/acuity-index-polkadot) is the first indexer built with Acuity Index Substrate. It can index Polkadot, Kusama, Westend and Rococo.

<img src="/diagram.svg" style="width: 100%; height: auto;" />
