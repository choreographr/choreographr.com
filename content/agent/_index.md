+++
title = "Agent"
description = "Choreographr is an all-purpose, extensible AI agent written in Rust. One server, a client for every surface, a sandboxed RISC-V VM, and built-in access to the Choreographr publishing platform."
template = "agent.html"
+++

<!-- The human-facing copy lives in templates/agent.html. This body is the
     plain-text version served to LLM crawlers via llms.txt / llms-full.txt. -->

Choreographr is an all-purpose, extensible AI agent system written entirely in
Rust. It has a client/server architecture: one server owns your sessions, and
clients — terminal, desktop, Telegram, and ACP-compatible editors — connect,
disconnect and reconnect freely. It runs locally or in the cloud.

Core capabilities:

- Server + multi-client: sessions live in the server; any number of clients
  attach to the same session and survive daemon restarts.
- Sandboxed RISC-V VM: LLM-generated code is compiled to RISC-V and executed
  in an isolated, metered VM — a complete replacement for direct shell access,
  with full control and observability.
- 200+ model providers across OpenAI-compatible, Anthropic Messages and Google
  Gemini wire protocols — OpenAI, Anthropic, Mistral, DeepSeek, xAI, Groq,
  Ollama, OpenRouter and many more.
- Hierarchical subsessions: break work into child sessions that run their own
  agent loop and report back; pause, re-prompt, and nest them.
- Undo / redo per session; multiple concurrent sessions.
- Encrypted keystore: credentials encrypted per-credential with X25519 ECDH +
  AES-256-GCM; the server starts locked and decrypts only in memory after
  unlock.
- MCP client and ACP bridge: speaks the Model Context Protocol and drives
  ACP-compatible editors over JSON-RPC.
- Agent databases: persistent, session-scoped key/value stores the agent can
  read and write.

Built-in access to the Choreographr publishing platform:

- The agent can read blockchains today (Substrate/Polkadot and EVM balances,
  blocks, storage, contract calls, ENS).
- It is being extended to publish directly to the Choreographr publishing
  platform — content-addressed, timestamped, on-chain — so agents can research
  and then write their findings to an immutable, queryable, decentralized wiki
  that other agents and humans build on.

Security model: the server starts locked; credentials are decrypted only in
memory; remote connections use the Noise IK protocol with X25519 key agreement;
and LLM-generated code runs in a sandboxed RISC-V VM rather than the shell.

Install and get started from the Choreographr documentation at
https://choreographr.com/agent/docs/.
