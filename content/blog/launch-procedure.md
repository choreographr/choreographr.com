+++
title = "Acuity DEX Launch Procedure"
description = 'The Acuity DEX is very nearly ready to launch. It will begin cross-chain trading of ACU, and coins and tokens on mainnet EVM blockchains.'
date = 2022-11-03
draft = false
template = "blog-page.html"

[taxonomies]
authors = ["Jonathan Brown"]

+++

<p>The Acuity DEX is very nearly ready to launch. It will begin cross-chain trading of ACU, and coins and tokens on mainnet EVM blockchains.</p>
<p>There are 4 smart contracts that need to be deployed to an EVM chain for it to be able to trade on the DEX:</p>
<p>
  <ul>
    <li><a target="_blank" href="https://github.com/acuity-social/acuity-atomic-swap-solidity/blob/main/src/AcuityAccount.sol">AcuityAccount</a> - enables accounts to be connected to an ACU account</li>
    <li><a target="_blank" href="https://github.com/acuity-social/acuity-atomic-swap-solidity/blob/main/src/AcuityAtomicSwap.sol">AcuityAtomicSwap</a> - enables trading of the base coin of the chain</li>
    <li><a target="_blank" href="https://github.com/acuity-social/acuity-atomic-swap-solidity/blob/main/src/AcuityAtomicSwapERC20.sol">AcuityAtomicSwapERC20</a> - enables trading of any ERC20 token on the chain</li>
    <li><a target="_blank" href="https://github.com/acuity-social/acuity-atomic-swap-solidity/blob/main/src/AcuityRPC.sol">AcuityRPC</a> - helper contracts to combine multiple chain queries</li>
  </ul>
</p>
<p>These contracts have already been deployed to the following chains:</p>
<p>
  <ul>
    <li><a target="_blank" href="https://www.optimism.io/">Optimism</a></li>
    <li><a target="_blank" href="https://www.avax.network/">Avalanche C-Chain</a></li>
    <li><a target="_blank" href="https://arbitrum.io/">Arbitrum One</a></li>
    <li><a target="_blank" href="https://nova.arbitrum.io/">Arbitrum Nova</a></li>
    <li><a target="_blank" href="https://polygon.technology/solutions/polygon-pos/">Polygon PoS</a></li>
  </ul>
</p>
<p>Many more EVM chains will be added over time.</p>
<p>Before the DEX web app can go live, the runtime of the Acuity blockchain must be upgraded via the governance mechanism. Before this can happen all ACU validators must upgrade to version <a target="_blank" href="https://github.com/acuity-social/acuity-substrate/releases/tag/v1.2.4">v1.2.4</a> of the Acuity full node software.</p>
<p>If you are an ACU validator, you can join the Staking channel on the <a target="_blank" href="https://discordapp.com/invite/GxD7adN">Acuity Discord</a> to discuss.</p>
</div>
