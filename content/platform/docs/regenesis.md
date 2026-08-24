+++
title = "Regenesis"
description = "ACU Regenesis."
date = 2025-04-27T08:20:00+00:00
updated = 2025-04-27T08:20:00+00:00
draft = false
weight = 50
template = "platform-doc.html"

+++

## Why did Acuity have a Regenesis?
Acuity is a fully decentralized social media platform that has been in development for six years, but it began as an independent Ethereum blockchain called MIX. The project has now migrated to a new <a target="_blank" href="https://polkadot.network/">Polkadot</a> blockchain with native cryptocurrency ACU. This has a number of advantages:

### Blockchain Interoperability

Acuity is being built with Polkadot's <a target="_blank" href="https://www.substrate.io/">Substrate</a> blockchain construction kit. Chains built with this technology can connect together for improved block finality, decentralized token exchange and message passing.

### Cheaper Transactions

Being an independent Ethereum blockchain, MIX has a lot of capacity and cheap transactions. However, as we have seen on the Ethereum mainnet, transactions can get expensive very easily once transaction throughput increases. Proof-of-stake blockchains built with Substrate have much greater capacity than a PoW Ethereum blockchain. This is very important for Acuity because it uses on-chain transactions extensively when publishing content.

### Massively Extensible

Substrate has a system called <a target="_blank" href="https://substrate.dev/docs/en/knowledgebase/runtime/frame">FRAME</a> that provides many pluggable pallets that can easily add functionality to the blockchain.

### Forkless Upgrades

Using the Democracy pallet the Acuity community can agree when to upgrade the blockchain and this will happen automatically without node software having to be manually upgraded.

### Reduced Supply Inflation

30k MIX was mined everyday, inflating the MIX supply by ~14% per year. After regenesis the ACU supply inflates due to staking rewards by only ~10% per year.

### WASM Smart Contracts

The Substrate Contracts pallet uses a WASM VM instead of the Ethereum VM. This greatly increases processing capacity.

## How did the migration happen?

On 1st September 2020 at 5am UTC a snapshot of all balances on MIX blockchain occurred. On 3rd September the new Acuity blockchain launched. All MIX holders have be allocated the same amount of ACU as they held in MIX at the time of the snapshot.
ACU can be claimed by signing a message from a MIX address using MyCrypto, MyEtherWallet, Metamask or Coinomi. Arun Goutham has published some excellent <a target="_blank" href="https://www.youtube.com/channel/UCbAIcinwIejHlpMAYHEA9dg">tutorials</a> on his YouTube channel.

## Was any extra ACU be created during Regenesis?
No. Only ACU that can be claimed 1:1 from MIX balances will come into existence during Regenesis.
