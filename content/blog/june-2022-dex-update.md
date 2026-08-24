+++
title = "DEX Development Update"
description = 'The Acuity DE will be a fully autonomous and decentralized atomic swap cross-chain cryptocurrency exchange. It will support ACU, and both base coins and ERC20 tokens on all EVM compatible chains. It has a number of advantages over other cross-chain exchanges &amp; bridges.'
date = 2022-06-15
draft = false
template = "blog-page.html"

[taxonomies]
authors = ["Jonathan Brown"]

+++

<p>The Acuity DEX will be a fully autonomous and decentralized atomic swap cross-chain cryptocurrency exchange. It will support ACU, and both base coins and ERC20 tokens on all EVM compatible chains. It has a number of advantages over other cross-chain exchanges &amp; bridges:</p>
<p>
  <ul>
    <li>Many cross-chain exchanges have centralized components, such as off-chain indexing and order matching. This leads to exchanges being required by authorities to require identity information of users. Because Acuity has has on-chain order discovery and is a fully autonomous peer-to-peer system there is no means by which it can be required to do anything.</li>
    <li>Bridges are an alternative to cross-chain trading where tokens can be "teleported" between blockchains and traded on regular on-chain exchanges. These typically have one of three problems: they are very complicated and can fail catastrophically; they are controlled by a small number of key holders; or they require both blockchains to be connected to the same "relay chain". Acuity DEX is a very simple peer-to-peer system that is not exposed to these issues.</li>
  </ul>
</p>


## Chains

<p>Acuity DEX is a webapp that uses browser wallets such as <a target="_blank" href="https://polkadot.js.org/extension/">Polkadot.js</a> and <a target="_blank" href="https://metamask.io/">MetaMask</a> for account management and writing transactions to blockchains. It will be able to trade between many different blockchains. It will monitor all of them for events relevant to the user.</p>
<p>In order to connect to each chain the user must select an endpoint URI. These can be either http(s):// or ws(s):// . wss is best because it is both encrypted and enables event subscriptions, athough not all wss endpoints have subscriptions enabled. Acuity will use polling in this case. Additionally, some endpoints do not support past event scanning which is necessary for the webapp to operate.
<p>For each chain, the user can select from a predefined list of public URIs, or enter a custom one. Public URIs are typically provided for free by organizations or companies. If an appropriate URI cannot be found the user will need to either run their own node for the chain, or pay for access to a high quality endpoint from a private company, such as <a target="_blank" href="https://blastapi.io/">Blast API</a>, <a target="_blank" href="https://infura.io/">Infura</a>, <a target="_blank" href="https://www.pokt.network/">Pocket</a>, <a target="_blank" href="https://www.cloudflare.com/en-gb/web3/">Cloudflare</a>, <a target="_blank" href="https://www.ankr.com/">Ankr</a>, etc.</p>

<img src="/blog/chains.png" style="width: 100%; height: auto;"></img>


## Stashes

<p>The DEX uses an on-chain order book on the Acuity blockchain. In order for seller's orders to be discoverable, funds need to be stashed in the <a target="_blank" href="https://github.com/acuity-social/acuity-atomic-swap-solidity/blob/main/src/AcuityAtomicSwap.sol">AcuityAtomicSwap.sol</a> smart contract in the selling chain. The contract records in an ordered linked list how much has been stashed by each seller for each trading pair. Funds can be stashed and unstashed at any time.</p>
<p>The on-chain ordered linked list means that the DEX webapp can instantly and without a centralized database obtain a list of sellers for each trading pair. Each seller's sell price can then be queried on the Acuity blockchain.</p>

<img src="/blog/stashes.png" style="width: 100%; height: auto;"></img>


## Trusted Accounts

<p>As ACU is an Acuity Social Parachain, it utilizes Trusted Accounts (blog post "Social Trading" below is now slightly outdated).</p>
<p>Trusted Accounts on the DEX can be used to see who trusts potential trading partners and for obtaining reliable price / volume trading data.</p>

<img src="/blog/trusted-accounts.png" style="width: 100%; height: auto;"></img>
