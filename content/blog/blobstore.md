+++
title = "BlobStore: immutable storage on Ethereum blockchains"
description = 'BlobStore is an Ethereum smart contract I have been developing on and off for about a year. In January I wrote a blog post about the properties of various decentralized storage technologies. BlobStore specifically targets Ethereum log storage. The premise is simple — store a blob (Binary Large OBject) and get an identifier for it (blobId). For the rest of time that blob can be retrieved using that blobId.'
date = 2016-11-19
draft = false
template = "blog-page.html"

[taxonomies]
authors = ["Jonathan Brown"]

+++

*Originally published at [medium.com](https://medium.com/mix-blockchain/blobstore-immutable-storage-on-ethereum-blockchains-8663304cd087)*

<p>Update: BlobStore is now called <a href="https://docs.mix-blockchain.org/en/latest/item_store.html" target="_blank">Item Store</a>.</p>

<p>BlobStore is an Ethereum smart contract I have been developing on and off for about a year. In January I wrote a blog post about the <a href="/blog/ethereum-text-publishing/">properties of various decentralized storage technologies</a>. BlobStore specifically targets <a href="https://docs.soliditylang.org/en/develop/contracts.html#events" target="_blank">Ethereum log storage</a>. The premise is simple — store a blob (<a href="https://en.wikipedia.org/wiki/Object_storage" target="_blank">Binary Large OBject</a>) and get an identifier for it - blobId). For the rest of time that blob can be retrieved using that blobId.</p>

<p>The contract has evolved quite substantially since I first wrote it to add more features such as ownership, configurability, rudimentary revisioning, contract upgradability, testing, and reduced gas costs.</p>

<p>Example use-cases for BlobStore are blog posts, tweets, Reddit posts, user profiles, media metadata, smart contract source code.</p>

<p>Version 1.0 has now been released. It has been deployed on Ethereum. I will also deploy it to Ethereum Classic and Expanse. It will be the primary contract on the soon-to-be-launched MIX Blockchain.</p>
