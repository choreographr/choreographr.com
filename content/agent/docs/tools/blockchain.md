+++
title = "Blockchain tools"
description = "Read-only EVM and Substrate/Polkadot queries (alloy/subxt)."
weight = 6
+++

The `blockchain` group adds read-only query tools for EVM
(Ethereum-compatible) and Substrate/Polkadot chains, built on `alloy` and
`subxt`. It is not active by default — activate it with
`load_tools blockchain`. The group is compiled in only when the daemon is
built with the `blockchain` cargo feature (enabled in the release binaries);
see [Installation](@/agent/docs/installation.md#blockchain-tools).

## EVM tools

Every EVM tool takes the node's JSON-RPC URL as `rpc_url` (any public or
private Ethereum-compatible endpoint works, e.g.
`https://ethereum-rpc.publicnode.com`).

| Tool | What it does |
|---|---|
| `evm_chain` | Chain ID, latest block number, gas price, max priority fee, and client version |
| `evm_balance` | Native ETH/coin balance of an address |
| `evm_token_balance` | ERC-20 token balance for an address (`token_address`, `address`), plus the token symbol |
| `evm_block` | Block details: number, hash, timestamp, transaction count, gas used/limit, base fee |
| `evm_transaction` | Transaction details by hash: block number, from/to, gas used, effective gas price, log count |
| `evm_call` | Read-only contract call (`to`, `data`, optional `block_tag`) — returns raw hex result bytes |
| `evm_gas` | Gas fee estimates: gas price, max priority fee, EIP-1559 fee estimation |
| `evm_logs` | Event logs, optionally filtered by `address`, `topic0`, and `from_block`/`to_block` |
| `evm_nonce` | Transaction count (nonce) for an address |
| `evm_resolve` | Resolve an ENS name to an address, or reverse-resolve an address to a name |

Block numbers and `block_tag`s accept a decimal number, `0x`-hex, or the
named tags `latest`, `finalized`, `safe`, `pending`, and `earliest`.

```json
{ "name": "evm_chain", "arguments": { "rpc_url": "https://ethereum-rpc.publicnode.com" } }
{ "name": "evm_balance", "arguments": { "rpc_url": "https://ethereum-rpc.publicnode.com", "address": "0xd8dA6BF26964aF9D7eEd9e03E53415D37aA96045" } }
{ "name": "evm_call", "arguments": { "rpc_url": "https://ethereum-rpc.publicnode.com", "to": "0x6B175474E89094C44Da98b954EedeAC495271d0F", "data": "0x70a08231000000000000000000000000d8dA6BF26964aF9D7eEd9e03E53415D37aA96045", "block_tag": "latest" } }
{ "name": "evm_resolve", "arguments": { "rpc_url": "https://ethereum-rpc.publicnode.com", "name_or_address": "vitalik.eth" } }
```

## Substrate/Polkadot tools

Each Substrate tool takes an optional `ws_url` (WebSocket endpoint); it
defaults to the public Polkadot RPC, `wss://rpc.polkadot.io`.

| Tool | What it does |
|---|---|
| `subxt_chain` | Chain name, chain type, node name/version, genesis hash, best/finalized block, system properties, and health |
| `subxt_balance` | Account balance for an SS58 address — `System.Account` info (free, reserved, frozen) |
| `subxt_query` | Decode a storage value by `pallet` and `storage_item` name (e.g. `System` / `Account`), with optional hex `key` bytes — returns JSON |
| `subxt_block` | Block details: number, hash, parent hash, state root, extrinsics root, and full block JSON |

```json
{ "name": "subxt_chain", "arguments": {} }
{ "name": "subxt_balance", "arguments": { "address": "15oF4uVJwmo4TdGW7VfQxNLavjCXviqxT9S1MgbjMNHr6Sp5" } }
{ "name": "subxt_query", "arguments": { "pallet": "System", "storage_item": "TotalIssuance" } }
{ "name": "subxt_block", "arguments": { "block_number": 20_000_000 } }
```

> All blockchain tools are **read-only** — they query nodes over HTTP/WebSocket
> and never sign transactions or move funds. The RPC endpoint is passed per
> call as an argument; no credentials are required.
