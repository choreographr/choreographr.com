+++
title = "ACU / ETH atomic swap exchange under development"
description = "I'm currently working on a very simple atomic swap exchange for Acuity. This will be implemented as a Solidity smart contract and deployed on both the Ethereum and Acuity blockchains so ACU can be traded with ETH in a fully decentralized manner and without any counterparty risk."
date = 2020-12-03
draft = false
template = "blog-page.html"

[taxonomies]
authors = ["Jonathan Brown"]

+++

<p>I'm currently working on a very simple <a target="_blank" href="https://en.bitcoin.it/wiki/Atomic_swap">atomic swap</a> exchange for Acuity. This will be implemented as a Solidity smart contract and deployed on both the Ethereum and Acuity blockchains so ACU can be traded with ETH in a fully decentralized manner and without any counterparty risk.</p>
<p>Those wishing to sell ACU will lock it up in the smart contract along with the ETH price they want to sell it for and a <a target="_blank" href="https://en.wikipedia.org/wiki/Cryptographic_hash_function">hash</a> of a random number. A buyer can deposit the ETH required into the smart contract on the Ethereum chain (along with the same hashed random number). At this point the seller can retrieve the ETH, but in doing so they reveal the random number. The buyer can then use this number to receive the ACU.</p>
<p>The offers will be stored on-chain in a linked list, ordered by the quantity that is for sale. Various timeouts exist so that if either party does not fulfil their side of the arrangement the other party can retrieve their funds. The process can happen very quickly if both parties are online, or over space space of several hours. The procedure can also operative in reverse where someone can lock up their ETH to sell it for a specific ACU price.</p>
<p>The frontend will be implemented directly in the Acuity web app you are using right now. It will require the simultaneous use of both the <a target="_blank" href="https://polkadot.js.org/extension/">Polkadot</a> and <a target="_blank" href="https://metamask.io/">Metamask</a> browser plugins.</p>
