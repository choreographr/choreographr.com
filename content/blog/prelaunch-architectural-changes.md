+++
title = "DEX Pre-Launch Architectural Changes"
description = 'It has been 21 months since then initial announcement of the Acuity DEX. While the core concept of the atomic swap has remained the same during that time, the rest of the system has been re-designed many times. This can be see both from the blog posts below and from the GitHub activity.'
date = 2022-09-17
draft = false
template = "blog-page.html"

[taxonomies]
authors = ["Jonathan Brown"]

+++

<p>It has been 21 months since then initial announcement of the Acuity DEX. While the core concept of the atomic swap has remained the same during that time, the rest of the system has been re-designed many times. This can be see both from the blog posts below and from the <a target="_blank" href="https://github.com/acuity-social/acuity-atomic-swap-solidity/commits/main">GitHub activity</a>.</p>
<p>We are almost ready to launch the exchange on a handful of EVM chains (Ethereum, Arbitrum One, Arbitrum Nova, Optimism, Polygon, Avalanche) and Acuity. This will enable fully autonomous peer-to-peer exchange of any pair of the base coin of these chains and all ERC20 tokens on the EVM chains.</p>
<p>The various forks of Ethereum (Classic, PoW and Fair) don't have publically accessible WSS endpoints, so we can't add them to the DEX yet.</p>
<p>One of the key components that needs to be autonomous in order for an exchange to be fully decentralized is sell order discovery. Sellers want to sell up to a certain amount of a crypto that they have for another crypto at a certain price. Buyers want to find these sellers so they can trade with them. If they can't find a suitable seller they can switch to become a seller and wait for a buyer to come along.</p>
<p>It is imperative that the order book is fully autonomous, otherwise you have to trust someone to run it and it can become a target for those who wish to manipulate or prevent access to the exchange. An earlier version of the DEX did have a centralized <a target="_blank" href="https://github.com/acuity-social/acuity-atomic-swap-offchain">order book indexer</a> written in Rust, but this was dropped from the architecture for this reason.</p>
<p>A key function of the order book is to eliminate spam orders and to enable orders to be searched for and found effectively. The decentralized order book technique that had been implemented for launch was as follows:</p>
<p>
  <ul>
    <li>Sellers stash the coins or tokens that they want to sell in a smart contract on the selling chain.</li>
    <li>For each trading pair, the smart contract maintains a <a target="_blank" href="https://en.wikipedia.org/wiki/Linked_list#Singly_linked_list">singly linked list</a> of accounts in order of stash size.</li>
    <li>Accounts that have stashed the most for the pair are at the top of the list. This means that spammers will by definition be at the bottom and can be excluded very easily.</li>
    <li>The seller's intended sell price and maximum sell quantity (if less than the stash) are stored on the Acuity blockchain. This is to minimise the transaction fees for changing price &amp; quantity.</li>
    <li>When a buyer wants to see a list of sell orders for a given pair, the appropriate smart contract on the selling chain is queried for the top stashes for the pair.</li>
    <li>The price and max quantity is then looked up on Acuity. Other information such as trust relationship between traders, or whether the seller is a bot can also be queried at this time.</li>
    <li>The buyer can optionally message the seller over IM such as Telegram.</li>
    <li>To commence the trade the buyer sends a transaction to the buy chain to start the atomic swap process (not documented here).</li>
  </ul>
</p>
<p>The whole process is demonstrated in <a target="_blank" href="https://www.youtube.com/watch?v=hfVbQ_59O6E">this video</a>. While this order book solution did work and could display sell orders for a pair instantaneously, it has a few issues:</p>
<p>
  <ul>
    <li>It adds a lot of complexity for the seller - they need to stash the sell asset against the buy asset before creating the sell order.</li>
    <li>If the seller changes their mind and want to sell the stash for something else they have to move it to a new stash. If they don't want to sell it any more they have to unstash.</li>
    <li>All of this stashing and unstashing increases transaction fees for both the seller and the buyer, potentially by a lot for busy pairs.</li>
    <li>Chains that do not have a VM (like Bitcoin) are completely excluded from the exchange.</li>
  </ul>
</p>
<p>These issues are going to be resolved by massively simplifying the exchange before it is launched. Here's how it will work:</p>
<p>
  <ul>
    <li>There's no stashing - sellers simply publish their sell orders on the Acuity blockchain. Sell orders are not indexed on-chain, therefore this is very cheap.</li>
    <li>The app will maintain an off-chain index of orders for a given pair on an ongoing basis.</li>
    <li>When the app starts monitoring a pair it will download all the sell orders for that pair from the Acuity blockchain, check on the selling chain that the sellers actually have what they are intending to sell, and index these orders.</li>
    <li>The Acuity transactions that add / modify / remove sell orders publish events. These events are detected by the app and cause it to update its index on an ongoing basis.</li>
    <li>This means sell orders can always be presented to the end user instantly.</li>
  </ul>
</p>
<p>So the new UI will be incredibly simple! The seller creates sell orders on the Acuity chain. They just need to ensure that the total of all the orders does not add up to more than they have in their linked account on the selling chain.</p>
<p>Because the atomic swap smart contracts now have the stash functionality <a target="_blank" href="https://github.com/acuity-social/acuity-atomic-swap-solidity/commit/b1f420f9cd7ea56ef6e49d624dfc8f4401e58ab8">ripped out</a> of them they are incredibly simple and gas-efficient. Creating a lock only writes to a single storage slot in the EVM and this is deleted when the lock is removed. Even on expensive chains like Ethereum the atomic swap will be extremely cheap.</p>


## Road To Launch

<p>
  <ul>
    <li>The EVM smart contracts for trading base coins and ERC20 tokens have had the stashing functionality removed and are essentially ready.</li>
    <li>The Acuity Substrate pallets needs to be updated to the new architecture.</li>
    <li>The Acuity blockchain needs to be upgraded to the new runtime.</li>
    <li>The DEX app needs to be updated to the new architecture.</li>
  </ul>
</p>
