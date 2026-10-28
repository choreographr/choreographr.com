+++
title = "Agent"
description = "Choreographr is an all-purpose, extensible AI agent written in Rust. One server, a client for every surface, a sandboxed RISC-V VM, and built-in access to the Content network."
template = "agent.html"
+++

<!-- The human-facing copy lives in templates/agent.html. This body is the
     plain-text version served to LLM crawlers via llms.txt / llms-full.txt. -->

Choreographr is an all-purpose, extensible AI agent system written entirely in
Rust. It has a client/server architecture: one server owns your sessions, and
clients — terminal and desktop — connect, disconnect and reconnect freely. It
runs locally or in the cloud.

Core capabilities:

- Server + multi-client: sessions live in the server; any number of clients
  attach to the same session and survive daemon restarts.
- Sandboxed RISC-V VM: LLM-generated code is compiled to RISC-V and executed
  in an isolated, metered VM — a complete replacement for direct shell access,
  with full control and observability.
- 200+ model providers across OpenAI-compatible, Anthropic Messages and Google
  Gemini wire protocols — OpenAI, Anthropic, Mistral, DeepSeek, xAI, Groq,
  Ollama, OpenRouter and many more. Accounts authenticate with an API key or an
  OAuth sign-in (including ChatGPT subscriptions), and OAuth grants are refreshed
  and rotated automatically.
- Hierarchical subsessions: break work into child sessions that run their own
  agent loop and report back; pause, re-prompt, and nest them.
- Undo / redo per session; multiple concurrent sessions.
- Encrypted keystore: credentials encrypted per-credential with X25519 ECDH +
  AES-256-GCM; the server starts locked and decrypts only in memory after
  unlock.
- Agent databases: persistent, session-scoped key/value stores the agent can
  read and write.

Other capabilities:

- MCP servers: Choreographr is a Model Context Protocol client — daemon-wide
  `mcp.json` plus trust-gated project `.mcp.json`, over a stdio subprocess or a
  remote Streamable HTTP endpoint. Server tools appear under an `mcp/<slug>`
  group. Remote servers can require an OAuth sign-in (PKCE, dynamic client
  registration, confidential clients), and the grant lives in the same encrypted
  keystore as provider credentials.
- Cross-session reading: `read_session` reads another session's conversation
  text, so a result researched in one session can be reused in another.
- Image generation and editing: the `image` group's `generate_image` produces an
  image from a text prompt and `edit_image` modifies existing ones (including
  images already in the session, via `@last`), through the session's
  image-capable provider (OpenAI Images, xAI, Google Gemini, z.ai/Zhipu GLM, or
  fal.ai). Results render inline in the terminal and are fed back through vision
  so the model can refine them.
- Prompt-cache affinity and warming: each request carries the session's real id
  in its provider's cache-affinity field, so a session's turns route to a warm
  prefix cache; optional cache warming keeps it warm through long tool runs.
- Vision input: `read_image` feeds an image to a vision-capable model.
- Blockchain reads: the `blockchain` group's read-only EVM and Substrate/Polkadot
  tools (balances, blocks, storage, contract calls, ENS).
- Web browsing: `retrieve_webpage` renders URLs (HTML, text, screenshot, PDF)
  in a local headless browser, so JavaScript-heavy and bot-protected sites work.
- Read-only diagnostics: the `debug` group's `session_inspect` dry-runs the
  request the daemon would build and flags reasoning-echo risks.
- Terminal client: `choreo-tui` offers guided first-run setup, an inline command
  palette, shell-style readline keybindings, per-session pin/archive, inline
  images, and terminal integration (window title and program status).

Security model: the server starts locked; credentials are decrypted only in
memory; the local socket and on-disk secrets are owner-only; remote connections
use the Noise protocol with X25519 key agreement (IK with a pinned server key,
XX on first contact); logs never contain prompts, responses, tool I/O, or
secrets; and LLM-generated code runs in a sandboxed RISC-V VM rather than the
shell.

Install and get started from the Choreographr documentation at
https://choreographr.com/agent/docs/.
