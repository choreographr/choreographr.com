+++
title = "Architectural changes to Acuity Atomic Swap DEX"
description = "The Acuity DEX has been making a huge amount of progress towards launching an MVP, as can be seen from recent videos."
date = 2022-02-06
draft = false
template = "blog-page.html"

[taxonomies]
authors = ["Jonathan Brown"]

+++

<p>The Acuity DEX has been making a huge amount of progress towards launching an MVP, as can be seen from recent <a target="_blank" href="https://www.youtube.com/channel/UCkvRVEWnTPWWYJQqPbYwyiw/videos">videos</a>.</p>
<p>A major goal in the design of the exchange has been to make it as autonomous as possible with all of the critical functionality written in <a target="_blank" href="https://github.com/acuity-social/acuity-atomic-swap-solidity">smart contracts</a> and Substrate <a target="_blank" href="https://github.com/acuity-social/acuity-atomic-swap-pallet">pallets</a>. This has had to be balanced against other concerns such as transaction fees. To this end it was decided to have an <a target="_blank" href="https://github.com/acuity-social/acuity-atomic-swap-off-chain">off-chain indexer</a> component written in Rust. It listens to relevent events on participating blockchains, indexes the data in a centralized database, and responds to WebSocket queries from the exchange app running in the browser.</p>
<p>This works extremely well, although it did add a lot of complexity to the system. While the indexer is read-only and does not have any control over the exchange it is still a central point of failure.</p>
<p>During testing it became apparent that the system could be simplified even further, removing the off-chain indexer, and reducing gas costs at the same time. This will make the Acuity DEX fully autonomous.</p>


## Autonomous Cross-chain Trading Protocol

<p>Here's how it works:</p>
<p>
  <ul>
    <li>The seller must link their ACU account to the account on the blockchain they are selling from. They do this by publishing the opposite address on both blockchains.</li>
    <li>The seller locks up funds in the Acuity smart contract on the blockchain they are selling from. In the transaction they indicate which asset they wish to buy. The smart contract maintains a singly-linked list for each pair with the largest deposits at the top. This is an anti-spam measure. The seller can add / remove funds at any time or change the asset to be bought.</li>
    <li>The seller then publishes their sell orders on the Acuity blockchain. Sell orders can be modified very cheaply because they are maintained in a dedicated pallet on the Acuity blockchain.</li>
    <li>For any given pair, the front-end (hosted on IPFS) can query the selling blockchain directly and get the list of deposits. It will then query the Acuity blockchain for each of these deposits to get their sell orders. These are then sorted and presented to the user in the UI.</li>
    <li>The buyer locks up funds to purchase from a specific sell order. The atomic swap proceeds in the same manner as the <a target="_blank" href="https://www.youtube.com/watch?v=XaHDJTpU7go">current implementation</a>.</li>
    <li>Other than blockchain transaction fees, there is no fee to trade on Acuity DEX.</li>
  </ul>
</p>
<p>Advantages over previous implementation:</p>
<p>
  <ul>
    <li>No central point of failure. The whole system is fully autonomous. No one can stop you from trading.</li>
    <li>Lower transaction fees - with the current implementation you have to pay for transactions on the selling blockchain even to change the price you wish to sell at. Now the order book is maintained in a native pallet on the Acuity blockchain.
    <li>Publishing of sell orders on the Acuity blockchain will increase the monetary velocity of ACU.</li>
    <li>We can launch sooner.</li>
  </ul>
</p>
<p>
  Just about any EVM-compatible blockchain will added to the exchange, including Ethereum, Optimism, Arbitrum, Ethereum Classic, Moonbeam, Avalanche and Solana. Initially only the base cryptocurrency of each blockchain will be supported. Later an improved version of the EVM smart contract will be deployed to all chains to enable cross-chain trading of all ERC20 tokens between all EVM blockchains.
</p>


## Staking &amp; Trading

<p>
  <a target="_blank" href="https://polkadot.acuity.social/#/staking">Staking</a> has been re-enabled on the Acuity blockchain. Become a nominator or validator to secure the network and increase your ACU holdings.
</p>
<p>
  Until the DEX launches, ACU can be traded OTC on <a target="_blank" href="https://discord.com/invite/GxD7adN">Discord</a>.
</p>
