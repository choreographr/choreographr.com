+++
title = "May 2021 Project Update"
description = "In line with the previous blog post and video, a new Acuity Substrate node implementation has been released."
date = 2021-05-05
draft = false
template = "blog-page.html"

[taxonomies]
authors = ["Jonathan Brown"]

+++

<p>In line with the previous blog post and <a target="_blank" href="https://www.youtube.com/watch?v=ipg6KQNcZ-k">video</a>, a new Acuity <a target="_blank" href="https://www.substrate.io/">Substrate</a> node implementation has been <a target="_blank" href="https://github.com/acuity-social/acuity-substrate/releases">released</a>.</p>
<p>The previous implementation was based on Kusama, which was causing a number of problems. The new implementation is based on <a target="_blank" href="https://github.com/substrate-developer-hub/substrate-node-template">substrate-node-template</a> and has the following advantages:</p>
<p><ul>
  <li>It is now possible to become a validator on the Acuity network. This is an important step for Acuity to become fully decentralized. The process for setting up an Acuity validator node is very similar to <a target="_blank" href="https://wiki.polkadot.network/docs/en/maintain-guides-how-to-validate-polkadot">Polkadot</a>.</li>
  <li>The <a target="_blank" href="https://www.substrate.io/kb/smart-contracts/contracts-pallet">Contracts</a> pallet has been enabled. This is key to deploying the <router-link to="/features">Features</router-link> brought across from MIX and also the <router-link to="/atomic-swap">Atomic Swap</router-link> decentralized exchange functionality.
  <li>If there is a problem with using the Contracts pallet, the <a target="_blank" href="https://www.substrate.io/kb/smart-contracts/evm-pallet">EVM</a> pallet can be enabled and the contracts compiled with the standard Solidity to EVM compiler.</li>
  <li>The codebase can be easily <a target="_blank" href="https://github.com/substrate-developer-hub/substrate-parachain-template">updated</a> for Acuity to be able to become a parachain on Polkadot or Kusama.</li>
</ul></p>
<p>Unfortunately, because it was not possible to upgrade the Acuity blockchain directly to the new runtime a <a target="_blank" href="https://wiki.polkadot.network/docs/glossary#hard-spoon">hard spoon</a> had to be performed. This involved taking a snapshot of all the ACU balances and unclaimed MIX balances and creating a new genesis specification. This has the following disadvantages:</p>
<p><ul>
  <li>2,000,000 blocks of history are no longer archived on the main chain.</li>
  <li>Account identity information has been lost. Registrars will need to enabled and on-chain identities re-established.</li>
  <li>The council has been reset and will need to be voted in again.</li>
  <li>Nominators will need to re-bond their stake and controller accounts.</li>
</ul></p>

## Community discussions moving to Matrix

<p>Until now the Discord and Telegram platforms have been the main places for discussions about Acuity. Ultimately, the goal is for these discussions to move to Acuity itself. In the mean time another group chat platform will become the primary place to discuss Acuity: <a target="_blank" href="https://matrix.org/">Matrix</a>.</p>
<p>Matrix has a lot in common with Acuity. It is open source, non-proprietary, and permissionlessly extensible. It is also quite different. It is more ephemeral and can be private, whereas Acuity is permanent and fully public. Acuity does not have the concept of a "home server", it is entirely serverless.</p>
<p>The <a target="_blank" href="https://matrix.to/#/+acuity:matrix.org">Acuity Community</a> on Matrix has been created. All Acuity group messaging communities including Discord and Telegram will now be strictly moderated. Only constructive messages will be permitted and there will be no price discussion.</p>
