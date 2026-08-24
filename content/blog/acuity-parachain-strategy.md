+++
title = "Acuity Parachain Strategy"
description = "The Polkadot ecosystem is evolving rapidly. Kusama will soon have parachains and Polkadot itself will follow. Parachains are a means of connecting together different blockchains in a hierarchy for shared security and asynchronous communication. Acuity will be a hierarchy within this hierarchy."
date = 2021-03-19
draft = false
template = "blog-page.html"

[taxonomies]
authors = ["Jonathan Brown"]

+++

<p>The <a target="_blank" href="https://polkadot.network/">Polkadot</a> ecosystem is evolving rapidly. <a target="_blank" href="https://kusama.network/">Kusama</a> will soon have <a target="_blank" href="https://wiki.polkadot.network/docs/en/learn-parachains">parachains</a> and Polkadot itself will follow. Parachains are a means of connecting together different blockchains in a hierarchy for shared security and asynchronous communication. Acuity will be a hierarchy within this hierarchy.</p>
<p>This is one of the most important reasons for MIX migrating to the Polkadot ecosystem as Acuity.</p>
<p>The long term vision is for Acuity to become a backbone for the fully decentralized web.</p>
<p>Acuity will have many different decentralized social communities, such as decentralized equivalents of Wikipedia, Stack Overflow, CouchSurfing, GoFundMe, DeviantArt, Flickr, Instagram, YouTube, GitHub, Ancestry, Quora, Reddit, Maps, private communities, software packaging repositories, etc. Typically <a target="_blank" href="https://ipfs.io/">IPFS</a> hashes will be stored on-chain and other on-chain state will connect the content together in different ways depending on the use-case. <a target="_blank" href="https://www.parity.io/substrate-off-chain-workers-secure-and-efficient-computing-intensive-tasks/">Off-chain</a> indexing can be used for node software to optionally have other derived state that is not consensus-critical.</p>
<p>The on-chain logic of Acuity communities will be totally robust and reliable, unlike just about any other social media platform. This will create huge confidence in the system. This is vital for system extensibility.</p>
<p>Ultimately, each Acuity social community will exist on its own parachain that connects to the Acuity relay chain. Additionally, each social community can shard further by acting as a relay chain with many parachains, each being a different content language such as English, French, etc. This further increases scalability.</p>
<p>The Acuity relay chain can connect to either the Polkadot or Kusama relay chains, either as a parachain or a parathread. This enables asynchronous communication with the rest of the Polkadot ecosystem. It will be much cheaper for Acuity social communities to connect to the Acuity relay chain, rather than Polkadot or Kusama directly.</p>
<p>However, the timescale for hierarchical parachains on Polkadot is <a target="_blank" href="https://www.youtube.com/watch?v=Yomudj2BCEo&t=1882s">2 to 3 years</a>.</p>
<p>This means in the short term we have a choice, either enable Acuity to connect to Polkadot / Kusama, or enable a single layer of parachain social communities to exist under the Acuity parachain.</p>
<p>The way forward is clear, Acuity needs to be able to become a parachain / parathread on Kusama / Polkadot at the earliest opportunity to be able to participate in the early network effects that MIX missed out on on Ethereum (being an independent Ethereum blockchain at the time).</p>
<p>The first Acuity community will be based on the original Solidity smart contracts <a target="_blank" href="https://github.com/acuity-social/acuity-contracts">developed</a> when Acuity was called MIX. The <a target="_blank" href="https://github.com/hyperledger-labs/solang">Solang</a> compiler is now mature enough to compile these to <a target="_blank" href="https://en.wikipedia.org/wiki/WebAssembly">Wasm</a> and can therefore be deployed on the <a target="_blank" href="https://www.substrate.io/kb/smart-contracts/contracts-pallet">Contracts</a> pallet on the Acuity blockchain.</p>
<p>Eventually, once Acuity can have its own parachains, social communities will be developed as native <a target="_blank" href="https://www.substrate.io/">Substrate</a> pallets on their own blockchains. Developers wishing to extend the on-chain functionality of such a community without going through the governance mechanism will be able to do so with smart contracts.</p>
<p>Currently the Acuity node software is based on Kusama. This does not provide what we need. In order for Acuity to be able to be a parachain, the node software needs to be rebuilt based on <a target="_blank" href="https://github.com/substrate-developer-hub/substrate-node-template">substrate-node-template</a>. This is not especially difficult and hopefully can be achieved without performing another <a target="_blank" href="https://wiki.polkadot.network/docs/glossary#hard-spoon">hard-spoon</a>.</p>
