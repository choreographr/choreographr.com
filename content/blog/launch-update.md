+++
title = "Acuity Atomic Swap DEX Launch Update"
description = 'The Acuity Atomic Swap Substrate pallet has been updated to the final design of the DEX. This means that ACU (and any other Substrate chain that deploys the pallet) will be able to be traded on Acuity DEX.'
date = 2022-08-17
draft = false
template = "blog-page.html"

[taxonomies]
authors = ["Jonathan Brown"]

+++

<p>The <a target="_blank" href="https://github.com/acuity-social/acuity-atomic-swap-pallet">Acuity Atomic Swap Substrate pallet</a> has been updated to the final design of the DEX. This means that ACU (and any other <a target="_blank" href="https://substrate.io/">Substrate</a> chain that deploys the pallet) will be able to be traded on Acuity DEX.</p>


## ERC20 Token Support

<p>Trading the base coin of EVM blockchains is handled by the <a target="_blank" href="https://github.com/acuity-social/acuity-atomic-swap-solidity/blob/main/src/AcuityAtomicSwap.sol">AcuityAtomicSwap</a> smart contract. <a target="_blank" href="https://github.com/acuity-social/acuity-atomic-swap-solidity/blob/main/src/AcuityAtomicSwapERC20.sol">AcuityAtomicSwapERC20</a> and unit tests have now been written to handle trading of ERC20 tokens. Traders will be able to swap any ERC20 token between any supported EVM blockchains. Well-known tokens are hardcoded in the DEX app for ease of use and to prevent scams.</p>

<img src="/blog/tokens.png" style="width: 100%; height: auto;"></img>


## Ethereum PoS Merge

<p>After the successful Görli testnet merge with its PoS beacon chain, the Ethereum mainet is <a target="_blank" href="https://blog.ethereum.org/2022/08/12/finalized-no-36/">scheduled</a> to follow around 15th September. There are at least two projects intending to continue the original PoW chain: <a target="_blank" href="https://twitter.com/EthereumPoW">EthereumPoW</a> and <a target="_blank" href="https://twitter.com/EthereumFair">Ethereum Fair</a>. This is essentially a massive airdrop to anyone who holds ETH or Ethereum tokens.</p>
<p>It is anticipated that there will be considerable demand for trade between the new PoS Ethereum and the PoW forks. Acuity DEX will support permissionless peer-to-peer trading of base coins and ERC20 tokens between these chains.</p>

## Road To Launch

<p>
  <ul>
    <li>Update front-end to support latest features</li>
    <li>Review all code for robustness and write more tests</li>
    <li>Update Acuity blockchain to latest runtime</li>
    <li>Deploy Acuity smart contracts to EVM chains</li>
  </ul>
</p>
<p>It is anticipated to have the DEX live before the Ethereum PoS Merge.</p>
