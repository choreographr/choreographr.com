+++
title = "Index The Event Log"
description = ""
date = 2025-04-27T08:20:00+00:00
updated = 2025-04-27T08:20:00+00:00
draft = false
weight = 80
template = "platform-doc.html"

+++

As part of the original research for Acuity, a blog post was published in January 2016, [Text publishing technologies for Ethereum dapps](/platform/blog/ethereum-text-publishing/). It analysed the properties of the various blockchain data storage locations.

For the pevious version of Acuity (called MIX, an independent Ethereum chain) it was ultimately decided to store content in IPFS and store the IPFS hash and timestamp directly in [contract state](https://github.com/acuity-network/acuity-contracts/blob/7dc93b1be8dc66ee11c88ec1379432df43ef2acc/src/acuity-item-store/AcuityItemStoreIpfsSha256.sol). This meant that for a given content item, a dapp could query contract state directly to get a list of the IPFS hash of each revision of the content. The content of the revision could then be retrieved from the IPFS network (if it is available).

While this kept things as simple as possible, it made transactions unnecessarily heavy.

In general data should only be stored in on-chain state if it needs to be able to be read by an on-chain program at a later time. For example, an account balance needs to be stored in state because a later transaction will need to check the current balance before a transfer can occur. A record of balance transfers does not need to be stored in state because it is not anticipated that this information would need to be read by any on-chain program.

Everything an on-chain program does should be recorded in the event log. Node software can store these events with the block that it was logged from. On-chain programs should guarantee that emitted logs are correct.

For the new version of Acuity (built on Polkadot) it was decided to emit content IPFS hashes as events instead of storing them in state. This massively reduces transaction weight and increases scalablity of the platform as a whole.

But how can a dapp find the IPFS hashes of revisions of a given content item?

In 2023, the Web3 Foundation funded the development of Hybrid Indexer (now called [Acuity Index](/platform/)) with 2 grants ([1](https://github.com/w3f/Grants-Program/blob/master/applications/hybrid.md),[2](https://github.com/w3f/Grants-Program/blob/master/applications/hybrid2.md)). For each Polkadot blockchain it facilitates the creation of an "indexing node" that can run alongside an archival node. The indexing node reads the events from all historical blocks and stores them in an indexed database for high performance querying.

A dapp running on Acuity can query an indexing node to get the IPFS hashes. Similarly, a wallet dapp can query an indexing node to get the record of balance transfers for an account.

Acuity Index will be extended to financially incentivize a network of "rich nodes" that will also provide pinning / searching of IPFS content, recommendation engines (the Algorithm), querying the mempool, AI queries and media transcoding. This will facilitate the creation of an on-chain content web with feature rich dapps.
