+++
title = "Federated Ethereum Blockchains"
description = 'In the aftermath of the DAO fork it occurred to me that there might be a better way for large Ethereum projects to exist on the Blockchain.'
date = 2016-07-25
draft = false
template = "blog-page.html"

[taxonomies]
authors = ["Jonathan Brown"]

+++

*Originally published on jonathanpatrick.me. [Retrieved](https://web.archive.org/web/20190917043658/http://jonathanpatrick.me/blog/federated-ethereum-blockchains) from the Wayback Machine.*

<p>In the aftermath of the DAO fork it occurred to me that there might be a better way for large Ethereum projects to exist on the Blockchain.</p>
<p>The idea is this: large projects should not use the main Ethereum or Ethereum Classic chains. Instead they should create their own independent blockchain specifically for their project. Smaller Ethereum projects could decide which of the Ethereum blockchains is the most appropriate to use. Which smart contracts do they need to integrate with most?</p>
<p>How would this work?</p>
<h2>Native token</h2>
<p>It is common for large Ethereum projects to issue a token. If a project exists on its own blockchain this token would be the native transaction crypto-fuel that gets mined. It can optionally have a pre-issue for initial investors (like Ether). This can serve as a means of revenue generation for the project. Even if the tokens do not have additional meaning specific to the project, they are still required for transaction fees and therefore will have value if the chain becomes popular. For a fixed quantity of tokens the block reward could be removed completely.</p>
<h2>Sharding</h2>
<p>One of the problems with current blockchain technology is that every node has to store everything. With Ethereum there are plans to implement sharding at some point in the future. Implementing a fresh blockchain for each major project is way to have sharding today. Ethereum full nodes would only sync the blockchains that they are utilising. If a project is going to be storing a very large amount of data on-chain, using a separate blockchain means not subjecting everyone else to huge storage requirements.</p>
<h2>Siloed communities</h2>
<p>The DAO fork has fractured our community. Many immutability fundamentalists such as myself found it highly distressing for a hard fork to be implemented to fix a problem in an individual smart contract. If The DAO had been implemented on its own blockchain the fork could have been implemented just on that blockchain. Those not using The DAO would not have cared as the immutability of their chains would not have been affected. The DAO community would definitely have forked the DAO chain as it would have been essentially useless without it. All of the strife could have been avoided.</p>
<p>In this way each community can have the level of immutability they require and the damaging effects of hard forks can be isolated.</p>
<h2>2-way peg</h2>
<p>The <a target="_blank" href="https://web.archive.org/web/20190917043658/https://medium.com/@ConsenSys/taking-stock-bitcoin-and-ethereum-4382f0a2f17">clever technique</a> called Sidechains or 2-way peg essentially allows tokens to be teleported back and forth between different blockchains. In this way Ether could have been teleported into the DAO blockchain in return for the DAO token.</p>
<h2>Token conversion</h2>
<p>Of course if each big project has a separate blockchain then it becomes necessary to have different tokens to pay for transactions in different projects. This can be eased by using services like ShapeShift. It should also be possible to convert tokens in an automated manner using smart contracts. One possibility that has been previously discussed is the ability to pay transaction fees using any token.</p>
<h2>Inter-blockchain communication</h2>
<p>It should certainly be possible for smart contracts to read state and issue transactions on other blockchains. This is a very new and evolving area. Essentially it would involve checking Merkle proofs from a foreign blockchain in a smart contract.</p>
<h2>More conservative adoption of new features</h2>
<p>Ethereum is changing rapidly. Every hard fork that introduces new functionality also runs the risk of something going wrong. By observing how new features perform on other Ethereum blockchains before deploying to app-specific blockchains risk can be reduced.</p>
<h2>Custom functionality</h2>
<p>Separate blockchains can of course modify how Ethereum works. Potentially making substantial changes to support a specific use case.</p>
<h2>Cheaper transactions</h2>
<p>Ethereum is still considered as too expensive for many applications. Transaction price in real terms is expected to go down eventually (scaling, mature fee market). With a custom chain many parameters relating to the price can be modified. Also a new chain may initially have a much lower price per token.</p>
<h2>Bigger transactions</h2>
<p>On the main Ethereum chains the transaction size is still quiet limited. This can cause problems for developers and users alike. With a custom chain the mining software can be configured to vote for bigger transactions.</p>
<h2>Token standard</h2>
<p>One of the advatages of creating tokens on the main Ethereum chains is that they can implement the token interface. This means software can be written to integrate any token. However this does not apply to tokens that are the crypto-fuel for other blockchains or tokens implemented on other blockchains. A standard needs to be defined so such tokens can be integrated in a generic fashion.</p>
<h2>Trans-blockchain accounts</h2>
<p>Ideally, account keys could be shared across multiple blockchains to ease identity management. However this enables transaction replay attacks. One way to solve this is to use different transaction nonces like the Ethereum testnet. However a <a target="_blank" href="https://github.com/ethereum/EIPs/issues/134">more generic solution</a> to this problem should be found.</p>
<h2>Blockchain-independent Mist</h2>
<p>The upcoming Ethereum dapp browser <a target="_blank" href="https://web.archive.org/web/20190917043658/https://github.com/ethereum/mist/releases">Mist</a> can only operate on one blockchain at a time. It would be really amazing if it could connect to multiple Ethereum blockchains simultaneously.</p>
<h2>Merged mining</h2>
<p>While Ethereum does not currently support merged mining, it is still possible in theory. If all Ethereum blockchains could share the same proof of work this would solve the problem of small blockchains being able to be attacked by a single actor with a large mining capacity.</p>
<p>I hereby encourage everyone starting a big project on Ethereum to consider implementing it on an independent blockchain and to improve blockchain interoperability.</p>
