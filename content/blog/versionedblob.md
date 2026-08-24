+++
title = "VersionedBlob: a poor man's Git built on Ethereum"
description = 'One of the potential use-cases for Ethereum is to create a fully decentralized Git. Git is already decentralized in many respects, but you still need to push/pull with a specific server. If something like Git was implemented on Ethereum you just need to connect to another Ethereum node on the network.'
date = 2015-08-19
draft = false
template = "blog-page.html"

[taxonomies]
authors = ["Jonathan Brown"]

+++

*Originally published on jonathanpatrick.me. [Retrieved](https://web.archive.org/web/20160305144209/http://jonathanpatrick.me/blog/versionedblob) from the Wayback Machine.*

<p>One of the potential use-cases for <a target="_blank" href="https://ethereum.org/">Ethereum</a> is to create a fully decentralized <a target="_blank" href="https://en.wikipedia.org/wiki/Git">Git</a>. Git is already decentralized in many respects, but you still need to push/pull with a specific server. If something like Git was implemented on Ethereum you just need to connect to another Ethereum node on the network.</p>
<p>I have created a <a target="_blank" href="https://github.com/ethernomad/ethereum-contracts/blob/master/versioned_blob.sol">100 line Ethereum contract</a> to illustrate how this could work. It has a very simple feature set. There can only be one file in the repository and there are no branches. But it does have access control and revision tagging.</p>
<p>Currently it stores the file directly in the contract. Potentially this could be quite expensive. Once <a target="_blank" href="https://web.archive.org/web/20160305144209/https://github.com/ethereum/cpp-ethereum/wiki/Swarm">Swarm</a> is live, it could be used to store the files more economically.</p>
<p>The Ethereum <a target="_blank" href="https://web.archive.org/web/20160305144209/https://github.com/ethereum/wiki/wiki/Solidity-Tutorial#events">log system</a> allows for data to be attached to transactions which can then be searched externally. However in <a target="_blank" href="https://web.archive.org/web/20160305144209/https://github.com/ethereum/go-ethereum/wiki/geth">Geth</a> this is not properly indexed yet so can be quite slow. Currently VersionedBlob stores the commit history in the contract, but this could just be written into the log instead.</p>
