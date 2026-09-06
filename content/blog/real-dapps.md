+++
title = "How To Build Real Dapps With Acuity Index"
description = "The Internet is being gradually locked down like a boiling frog, undermining our potential to resist tyranny. Before long all Internet devices and services will require ID verification and VPNs will be banned."
date = 2026-04-30
draft = false
template = "blog-page.html"

[taxonomies]
authors = ["Jonathan Brown"]

+++

The Internet is being gradually [locked down](https://youtu.be/RE51m6JnYMo) like a boiling frog, undermining our potential to resist tyranny. Before long all Internet devices and services will require ID verification and VPNs will be banned.

Of course, in Web3, the theory is that dapps can provide peer-to-peer means of coordination. While there has been some success in this regard, it has yet to really take the world by storm in the way that the Web did in a few short years.

Most on-chain programs are not really permissionless and those that *are* typically require a centralized backend to function. Decoupling of transaction publishing from the backend does have a lot of good properties, but dapps reliant on backends are still vulnerable to capture.

For a dapp to provide a rich user experience it needs various services that are inherently centralized. For example:
* **Full Node** - State needs to be queried.
* **Event Indexer** - State is kept as minimal as possible to keep transaction fees low. Emitting events is the solution, but there needs to be a centralized database of events that can be queried.
* **IPFS Pinner** - Content published via IPFS does not stay available by itself. An always-on service must "pin" content for it to be available to other users.
* **IPFS Address Cache** - It can take too long for a dapp to find who has the required IPFS content. An address cache can make this immediate, but this is an always-on, shared service.
* **Content Search** - Full text search is expected in a modern app, but this is an inherently centralized service.
* **AI** - Users want powerful AI features that they will not run on their local device.

While these services are essentially impossible to implement in a peer-to-peer manner, they can be implemented in a federated manner provided they are standardized. If there is a flock of available backend providers to pick from, the dapp can switch ad-hoc between them. 

When querying untrusted backends it is essential that there is a system to prove the data is correct. In the Polkadot ecosystem, the dapp can run a light client to use finality proofs to ensure state queries are correct.

When querying an event indexer it is also possible to verify the events are correct using finality proofs. Although, it is not possible to guarantee that the indexer has not left out some results. This can be helped by querying multiple indexers run by different groups.

If the IPFS hash is proven to be correct by a finality proof, then the content retrieved from IPFS is guaranteed to be correct.

Positive content search results can be verified by examining the content. Again, it is not possible to prove that a search service has left something out, but a dapp can query different services over time to determine which ones are trustworthy.

Users could use multiple IPFS pinning services to ensure content remains available.

As there are multiple providers, they will compete against each other on various criteria.


## What is Acuity Index?

[Acuity Index](/content/) is part of the broader [Acuity](/content/) decentralized CMS.

It is a federated, multi-chain Polkadot event indexer with finality proofs, primarily intended to make dapps fully decentralized.

It was originally called Hybrid and was funded by two ([1](https://github.com/w3f/Grants-Program/blob/master/applications/hybrid.md), [2](https://github.com/w3f/Grants-Program/blob/master/applications/hybrid2.md)) Web3 Foundation grants and a Kusama Treasury [referendum](https://kusama.subsquare.io/referenda/534). A second funding referendum [failed](https://kusama.subsquare.io/referenda/567). Treasury funding for a Kusama Forum based on Acuity Index has been [secured](https://kusama.subsquare.io/referenda/603).

[Acuity Index 0.8.0](https://crates.io/crates/acuity-index/0.8.0) has just been released for experimentation. It has the following features:

- Config-driven indexing with support for compound keys and multi-keys
- Index specification checkpointing. When a new checkpoint is added re-indexing will occur from that block.
- Hot reload for accepted index-spec changes
- Concurrent backfill and head catch-up
- Asynchronous and multithreaded design for maximum node indexing performance
(63.1k events per second on AMD Ryzen 7 6800HS Creator Edition (16) @ 4.79 GHz)
- Finality proofs that can be verified by a light client running in the dapp
- Key subscriptions - notify dapp as soon as the key is included in a block
- Event variant indexing - search for or subscribe to all events of a certain type
- Prometheus / OpenMetrics monitoring
- Full unit and integration testing

Examine the [documentation](/content/) to see how it works.

Here's a screencast showing how a dapp can query events with Acuity Index to create a rich user interface:

[<img src="/take-back-the-web.jpg" style="width: 100%; height: auto;"></img>](https://youtu.be/V5QZNv3niKo?t=150)

Here's the [repo](https://github.com/acuity-network/acuity-dioxus) for the dapp.

## Federated Indexing

<img src="/acuity-index.svg" style="width: 100%; height: auto;"></img>

While an instance of Acuity Index can be hosted and a dapp hard-wired to use it, the intention is that there are multiple indexes available for each dapp.
The idea is that anyone can host a standardized index and potentially get paid to do so. Here is how it will work.

The Acuity DAO will establish the correct index spec for a given chain. Anyone hosting that index for the public can pay a deposit to register their endpoint on the Acuity blockchain. There is a micropayment system where dapps can query different providers in an ad-hoc manner, determining which ones tend to work the best and charge the least. The fees are paid to the index operator in ACU, the native coin of the Acuity blockchain. The dapp user has the option to pay in any currency as this will be routed through the [Hydration](https://hydration.net/) exchange on Polkadot.

Acuity Index will also provide access to state queries on the full node. Over time this will be expanded to all the other federated services that dapps need access to.

## Building the Ecosystem

Who I am looking for:

**Chain Builders** 

I want to add all Substrate-based chains to the platform. This will involve working with the teams to determine the correct index specification for the chain and then registering this on the Acuity blockchain.

**Index Providers**

Those who are interested in running indexes and registering on-chain so dapps can utilize them.

**Dapp Developers**

Querying event indexes is an extremely powerful technique for dapps. Reach out if you would like me to help build a dapp with Acuity Index.

<hr/>

If you are interested in participating, don't hesitate to reach out. My contact details:
* telegram: @ethernomad
* email: jbrown@acuity.network

