+++
title = "Social Trading"
description = "The Acuity Atomic Swap DEX is a spin-out project from the broader Acuity Decentralized Social Media project. Acuity is a rebuild of the MIX social media platform from Ethereum to Substrate."
date = 2022-04-18
draft = false
template = "blog-page.html"

[taxonomies]
authors = ["Jonathan Brown"]

+++

<p>The Acuity Atomic Swap DEX is a spin-out project from the broader Acuity Decentralized Social Media project. Acuity is a rebuild of the MIX social media platform from Ethereum to <a target="_blank" href="https://substrate.io/">Substrate</a>.</p>
<p>On Acuity, each social community is a separate Substrate parachain. Anyone can design a new concept for how they want their community to operate, launch their own parachain, and connect it to the Acuity relay chain for shared security and cross-community communication. The ACU chain is an Acuity social parachain dedicated to the atomic swap DEX. It has a <a target="_blank" href="https://github.com/acuity-social/acuity-orderbook-pallet">Substrate pallet</a> for on-chain publication of user's order books.</p>
<p>The Acuity DEX will enable fully decentralized trading between all pair combinations of all coins and tokens in the Acuity ecosystem and all EVM / WASM compatible chains (Ethereum, Classic, Optimism, Arbitrum, Moonbeam, Kulupu, Neatcoin, Avalanche, Solana, SmartBCH).</p>
<p>One of the key technologies that is being brought across from MIX to Acuity is Trusted Accounts. Essentially this enables users to create an on-chain public list of other users that they trust. An extended trust network is defined as all the users a user trusts, plus all the users that are trusted by users they trust.</p>
<p>If a user does a poor job of deciding who they should trust, they will be punished by not being trusted by others.</p>
<p>Trusted Accounts have many important use-cases. Here is the original <a target="_blank" href="https://medium.com/mix-blockchain/how-illegal-and-immoral-content-will-be-handled-on-mix-blockchain-e32fc25bc42f">blog post</a> and <a target="_blank" href="https://www.youtube.com/watch?v=j8WfGYxBERo">video</a> from MIX. (Note, I haven't re-read the blog post because it is on medium.com and it is blocked from my location. You may need to use a VPN to access it.)</p>
<p>On MIX, Trusted Accounts were <a target="_blank" href="https://github.com/acuity-social/acuity-contracts/tree/master/src/acuity-trusted-accounts">implemented</a> as a Solidity smart contract. Porting the functionality to a Substrate pallet is <a target="_blank" href="https://github.com/acuity-social/acuity-trusted-accounts-pallet">almost complete</a>. It is useful in a number of ways for the Acuity DEX:</p>
<p>
  <ul>
    <li>Seller discovery - as a buyer you can see all sell orders from everyone in your extended trusted network.</li>
    <li>Obtaining reliable trading data - a major problem with exchanges is fake trades. This can affect both pricing and volume data. On a decentralized exchange such as Acuity, it is very easy for someone to trade with themselves at any price and volume. Because of this it is not a good idea to harvest data from all the trades on the platform. A better way is to limit trading data to only come from trades made by those within your extended trust network.</li>
    <li>Reducing transaction fees - in earlier implementations of the Acuity DEX the smart contracts to be deployed to the trading chains had on-chain linked lists as a anti-spam and lock discovery measure. This increased transaction fees on the trading chains. With the Trusted Accounts network on the Acuity chain the complexity of the implementation deployed to the trading chains can be significantly reduced. Buyers will only see sell orders from their extended trust network. Sellers will be notified of buy locks by events on the buying chain.</li>
    <li>Less transactions - the quantity of blockchain transactions required to facilitate trades on the Acuity DEX is reduced. Previously the seller had to lock up their funds against a specific asset to buy so they could be indexed in the linked list on-chain. Now buyers can simply examine the quantity of funds the seller has stored at their address to determine if they have the funds necessary to complete a trade.</li>
    <li>More flexibility - sellers can create multiple sell orders for the same funds so they can attempt to sell it for many different assets simultaneously.</li>
  </ul>
</p>
<p>
  To connect with the Acuity please join <a target="_blank" href="https://t.me/acuity_social">Telegram</a> or <a target="_blank" href="https://discord.com/invite/GxD7adN">Discord</a>.
  Until the DEX launches, ACU can be traded OTC on Discord.
</p>
