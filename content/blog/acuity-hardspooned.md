+++
title = "Acuity hard spooned!"
description = 'Due to the cessation of block production of the proof-of-authority nodes (see previous blog post), it was necessary for Acuity to hard spoon. A snapshot of blockchain state was taken at block 1049095 (the last finalized block) and a new genesis block was created.'
date = 2020-11-26
draft = false
template = "blog-page.html"

[taxonomies]
authors = ["Jonathan Brown"]

+++

<p>Due to the cessation of block production of the proof-of-authority nodes (see previous blog post), it was necessary for Acuity to <a target="_blank" href="https://wiki.polkadot.network/docs/glossary#hard-spoon">hard spoon</a>. A snapshot of blockchain state was taken at block 1049095 (the last finalized block) and a new genesis block was created.</p>
<p>Two modifications to the state were made:
  <ul>
    <li>runtime upgrade - Built with the latest version of <a target="_blank" href="https://github.com/acuity-social/acuity-substrate">acuity-substrate</a>, this may fix the problem of new validators being unable to join the network  (and prevent cessation of block production from re-occuring).</li>
    <li>sudo pallet - I have given myself admin access to the blockchain. This means I can fix any problems immediately and perform network upgrades without going through the governance mechanism. This feature will be removed once Acuity is more mature.</li>
  </ul>
</p>
<p>The blockchain has restarted from a fresh block 0. Let me know if anything is not as expected. The emphasis now is to ensure ACU can be traded freely. This will involve integrating with centralized exchanges, integrating with atomic swap decentralized exchanges (or building our own), and creating Wrapped ACU as an Ethereum ERC20 token.</p>
<p>Really sorry for this extended outage - let's march forward with creating the most fully decentralized social media platform in existence!</p>
