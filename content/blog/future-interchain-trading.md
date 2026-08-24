+++
title = "Acuity Atomic Swap DEX - the future of interchain trading"
description = "First a little back-story on the history of Acuity... Acuity (previously known as MIX) was started in 2015 with the goal of creating on-chain social communities. These have many useful properties that are not available on centralized platforms."
date = 2021-12-04
draft = false
template = "blog-page.html"

[taxonomies]
authors = ["Jonathan Brown"]

+++

<p>First a little back-story on the history of Acuity...</p>
<p>Acuity (previously known as MIX) was started in 2015 with the goal of creating on-chain social communities. These have many useful properties that are not available on centralized platforms including:</p>
<p>
  <ul>
    <li>permissionless innovation: everyone is at liberty to improve the platform</li>
    <li>separation of data and functionality: you can create an entirely new social platform and bring in all the existing users</li>
    <li>censorship resistance: you can always publish - of course whether any one is listening is another matter</li>
    <li><a target="_blank" href="https://en.wikipedia.org/wiki/Link_rot">link rot</a> prevention: each piece of content has a permanent id and anyone can ensure that the content remains hosted</li>
  </ul>
</p>
<p>MIX was built on a clone of Ethereum and achieved a minimum viable product as can be seen on the <a target="_blank" href="https://www.youtube.com/channel/UCkvRVEWnTPWWYJQqPbYwyiw/videos">Acuity YouTube channel</a>.</p>
<p>At that time DeFi and scalable programmable blockchains were still only an idea. While we knew centralized exchanges were bad and DeFi was the way forward, it was decided to concentrate on the primary goal of the project (on-chain social communities). This meant that the coin for the project (MIX) was traded on centralized exchanges with the intention of migrating trading to DeFi once the technology was available.</p>
<p>On the 3rd September 2020 MIX migrated from a clone of Ethereum to the Polkadot ecosystem. The new blockchain is known as Acuity. All MIX balances could and still can be converted to ACU.</p>
<p>Polkadot is a much more suitable technology for on-chain social communities. It has a scalability model where there are many different high performance parachains with their own governance that can connect together via a "relay chain" for shared security and communication.</p>
<p>When designing on-chain social communities there is unlimited potential for innovation. This is why the goal with Acuity on Polkadot is that each on-chain social community will have its own parachain. Each community can operate in its own way while still being able to communicate via the Acuity relay chain with other parachain communities.</p>


## The problem...

<p>However it became apparent that centralized exchanges are an obstacle for Acuity and the broader blockchain movement.</p>
<p>The issue is that when a centralized exchange lists a coin, they are actually creating a totally new coin that is simply stored in a database that they control. The exchange operator uses public relations to ensure that in the mind of coin holders a real coin (the owner is in possession of the private key) is equivalent to a coin held on the exchange.</p>
<p>However this couldn't be further from the truth. Cryptocurrencies are generally said to have certain important properties, such as having deterministic inflation rate and the fact that they are "sound money" that can't be counterfeited. While this may be true on the blockchain, this is most certainly not true on centralized exchanges.</p>
<p>Because operators of CEXs are in control of the database of their cryptocurrency, they have the technical ability to create arbitrary amounts of it as they see fit and use this fake cryptocurrency to benefit themselves.</p>
<p>For example, they can create arbitrary quantities of coin A and sell it for coin B on their own exchange, thereby lowering the value of coin A and raising the value of coin B. This means they know the future. There are many ways this can be used to generate large profits. For example, they can:</p>
<p>
  <ul>
    <li>obtain large quantities of coin B before raising its value, then sell it OTC</li>
    <li>start positive feedback buying loop of coin B where many unsuspecting traders also participate, before selling at the top</li>
    <li>short coin A against another coin</li>
    <li>conspire with other CEXs to work in lockstep, thereby increasing profits</li>
    <li>sell information about the future, e.g. paywalled mailing lists</li>
    <li>do all of this over and over again</li>
  </ul>
</p>
<p>So CEXs have the potential to be parasites, sucking value out of crypto projects. They have the power to decide the winners and losers.</p>
<p>On proof-of-stake blockchains and those that use stake for governance (like Polkadot) the situation is even worse. CEXs can use their power to accumulate vast real quantities of a specific cryptocurrency and then use it to interfere with the governance of the chain.</p>
<p>CEXs can operate like banks, only keeping a fractional reserve of deposits. This is totally invisible unless they become completely insolvent, at which point the exchange will shut down.</p>
<p>CEX operators may start out with the intention of being corrupt or they may become corrupt over time, either because the temptation is too great or because they make a technical error and loose funds that need to be recovered. Either way we are trusting CEXs to not be corrupt. This goes against the fundamental purpose of blockchain - having rules without having to trust anyone.</p>
<p>Exchange rates on major centralized exchanges are generally quite similar to those on DeFi, showing that the community really believes that coins on a CEX are equivalent to those on a DEX. Price aggregation websites combine the exchange rates of centralized exchanges with those from DeFi, further propagating the myth.</p>
<p>Of course the other issue with centralized exchanges is that you have no guarantee that you can convert your CEX coins into real coins. Many people have lost crypto over the years because they have been unable to withdraw it.</p>
<p>ACU is currently trading on <a target="_blank" href="https://www.stex.com/">STEX</a>. They have treated us very well and they do not appear to be corrupt.</p>


## The solution...

<p>DeFi solves this problem. Trading on DeFi does not involve depositing crypto into a centralized system that credits you with tokens in a controlled database. Trading occurs via smart contracts that operate in a fully deterministic manner. There is no need to trust a third party.</p>
<p>DeFi on a single blockchain, for example Uniswap, has been very successful. But what we really need to replace centralized exchanges is cross-chain DeFi.</p>
<p>There are various ways this can be done, for example with <a target="_blank" href="https://wiki.polkadot.network/docs/learn-bridges">Polkadot Bridges</a>. This enables tokens to be "teleported" from one chain to another where they can be traded using regular on-chain DeFi.</p>
<p>Another way that has been discussed since the early days of Bitcoin, but not fully realized, is <a target="_blank" href="https://www.youtube.com/watch?v=-9NDKbJo_A4">Atomic Swap</a>. This enables direct trading from wallet to wallet across blockchains. With atomic swap either both the buy and sell transfers occur or neither of them do.</p>
<p>It was announced on 3rd December 2020 that development had started on the <router-link to="/atomic-swap">Acuity DEX</router-link>.</p>
<p>Development of the DEX is now very mature. On testnets it is possible to create ACU sell orders and match them with ETH. <a target="_blank" href="https://www.youtube.com/watch?v=9-DvgMzOtis">Here's the video</a>.</p>
<p>The next step is to implement the UI for sales in the other direction (creating ETH sell orders and matching them with ACU). We will then have the minimal viable product. After that we will be adding support for many more programmable blockchains (Optimism, Arbitrum, Polkadot chains, Avalanche, Solana, etc) and also all tokens within those blockchains.</p>
<p>The UI will need to be improved a lot. This is an ongoing process.</p>
<p>Atomic Swaps operate with a system of timeouts. If either party doesn't do what is required of them the other party simply has to wait for the timeout to expire. The timeout duration can be negotiated by both parties before the trade starts. For fast blockchains and bot or bot-assisted trading these timeouts can be just a few seconds long, resulting in high frequency trading.</p>
<p>An important aspect of Atomic Swap trading is that you need to be able to view the reputation of potential trading partners. The Acuity DEX will have an on-chain review / rating system, storing IPFS hashes of comments. Essentially the first parachain social community on Acuity. In order to publish reviews of your trading partners it will be necessary to spend a small amount of ACU to pay for the transaction.</p>
<p>For example a trade could happen between Avalanche and Solana, and the traders would pay a small amount of ACU to review it.</p>


## Hard spoon

<p>Before we can launch the exchange we need to perform a <a target="_blank" href="https://wiki.polkadot.network/docs/glossary#hard-spoon">hard spoon</a> to upgrade the blockchain. This will be the third (and hopefully final) hard spoon that we have performed on the Acuity blockchain. This will occur over the next few days. A snapshot of all ACU balances will be taken and a new genesis block will be created. You do not need to take any action before the hard spoon.</p>
<p>Any ACU you have locked or staked will be credited to your account. Nominators and validators can be setup again after the hard spoon.</p>
