+++
title = "Acuity Atomic Swap DEX begins public testing"
description = 'On July 11th 2022 the first cross-chain trade on Acuity Testnet occurred between Estonia and Vietnam. 0.02 Rinkeby was bought with 0.002 Ropsten. The Acuity Atomic Swap DEX is ready for general testing.'
date = 2022-07-14
draft = false
template = "blog-page.html"

[taxonomies]
authors = ["Jonathan Brown"]

+++

<p>On July 11th 2022 the <a target="_blank" href="https://twitter.com/phukestcom/status/1546160700422225924">first</a> cross-chain trade on Acuity Testnet occurred between Estonia and Vietnam. 0.02 Rinkeby was bought with 0.002 Ropsten. The <router-link to="/atomic-swap">Acuity Atomic Swap DEX</router-link> is ready for general testing.</p>

<img src="/blog/first-trade.png" style="width: 100%; height: auto;"></img>

<p>The DEX has a unique design in that it is a cross-chain exchange that is fully autonomous. Typically cross-chain exchanges require centralized coordination systems to operate. This leads to various problems such as downtime and increased attack surface.</p>
<p>Because Acuity DEX is fully autonomous (like an on-chain smart contract) it is not susceptible to these issues.</p>

## How does it work?

<p>There is no backend whatsoever. The web app connects to the Acuity blockchain and all the chains you wish to trade on. It maintains permanent connections for monitoring via Websockets. Transactions are broadcast via the Polkadot and Metamask browser extensions.</p>
<p>Traders set their account name on the Acuity blockchain.</p>
<p>Traders prove that they are in control of their accounts on other blockchains by publishing those account addresses on the Acuity blockchain and publishing their Acuity address on the other blockchains.</p>
<p>The seller must stash what they want to sell in the <a target="_blank" href="https://github.com/acuity-social/acuity-atomic-swap-solidity/blob/main/src/AcuityAtomicSwap.sol">Acuity Atomic Swap</a> smart contract on the selling chain. If they wanted to sell ETH for AVAX, they stash their ETH in the ETH / AVAX pair. For each pair the contract maintains a linked list of stashes with the largest first. This is the decentralized sell order discoverability mechanism. With a simple query to the smart contract the app can find the largest sellers for a pair. Spammers will be relegated to the bottom of the list and ignored.</p>
<p>The seller publishes their sell quantity and price for the pair on the Acuity blockchain. ACU transactions are extremely cheap so the sell order can be modified very cheaply.</p>
<p>When a buyer wishes to purchase from the sell order they create a buy lock in the smart contract on the buy chain for the correct amount. Only the buyer knows the secret. The hash of the secret is known publically.</p>
<p>The seller then creates a buy lock in the smart contract on the selling chain using the hash of the secret, moving the funds from the stash.</p>
<p>Both the buyer and the seller have now created their locks, but only the buyer knows the secret.</p>
<p>The buyer then unlocks the sell lock with the secret, taking what has been sold. In doing so they reveal the secret meaning that the seller can then unlock the buy lock, taking what was used to pay for the purchase.</p>
<p>At no point was there any counterparty risk because if either party fails to fulfill their part of the deal, the other party can just wait for the lock to time out and get their funds back.</p>
<p>The whole process can be seen in this <a target="_blank" href="https://www.youtube.com/watch?v=hfVbQ_59O6E">technology preview video</a>.</p>

## Fees

<p>Because the DEX is fully autonomous, there are no fees being paid out to centralized entities. Blockchain transaction fees need to be paid for:</p>
<p>
  <ul>
    <li>Stashing on the sell chain.</li>
    <li>Setting sell orders on Acuity.</li>
    <li>Creating and unlocking locks on the buy chain.</li>
    <li>Creating and unlocking locks on the sell chain.</li>
  </ul>
</p>

## Help us test the DEX

<p>Before we can launch with mainnet trading, the web app requires testing and further development. If you would like to test the DEX web app and experience the future of fully decentralized autonomous cross-chain trading, please join our <a target="_blank" href="https://t.me/Acuity_Trading">Acuity Trading</a> Telegram group and let yourself be known. You will be provided with some Test ACU. Visit the web app at: <a target="_blank" href="https://dex.acuity.social/">https://dex.acuity.social/</a>. You'll need to install both the <a target="_blank" href="https://polkadot.js.org/extension/">Polkadot</a> and <a target="_blank" href="https://metamask.io/download/">MetaMask</a> browser extensions. The following testnets are currently supported:</p>
<p>
  <ul>
    <li>Ropsten</li>
    <li>Rinkeby</li>
    <li>Görli</li>
    <li>Kovan</li>
    <li>Moonbase Alpha</li>
    <li>Avalanche Fuji</li>
    <li>Polygon Mumbai</li>
    <li>Arbitrum Nitro</li>
  </ul>
</p>

## Future Features

<p>
  <ul>
    <li>Enable trading of ACU. As Acuity is a Substrate blockchain the Acuity Atomic Swap pallet needs to be updated before ACU can be traded on the DEX.</li>
    <li>ERC20 support: currently only the base coin of each blockchain can be traded. The ERC20 variant of our atomic swap smart contract will need to be finished. This will enable all tokens on all Ethereum-compatible blockchains to be traded autonomously.</li>
    <li>There needs to be a hot wallet within the web app. This will automate the whole trading process, creating and unlocking locks as necessary.</li>
    <li>Market price determination. The app needs to be able to determine the current market price of an asset by examining recent trades within the user's trust network.</li>
    <li>The web app will be available via IPFS.</li>
    <li>The app will also be available as a desktop app.</li>
    <li>Intra-chain trading.</li>
    <li>NFT trading.</li>
  </ul>
</p>
