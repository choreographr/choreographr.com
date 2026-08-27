+++
title = "Architecture"
description = "Threading model, workspace topology, and where to find the deep dive."
weight = 9
+++

The full architecture deep-dive lives in the repository at `ARCHITECTURE.md`.
This page is a short orientation.

## Client/server topology

Choreographr separates the daemon that runs sessions from the clients that
connect and disconnect at any time.

![Architecture diagram: daemon with TUI, GUI, IM, ACP and daemon clients, model providers, and the RISC-V VM sandbox](/architecture.svg)

- The client can run on the same computer as the daemon (via a local Unix
  socket), or the daemon can live anywhere on your local network or the
  Internet.
- When connecting remotely, clients use **Noise-IK** encrypted TCP.
- Because the daemon can live anywhere and is reachable over encrypted TCP, it
  can also be reached from mobile devices — for example, chatting with your
  agent on the go via the `choreo-im` Telegram bridge.
- Daemons can also connect to each other — `choreo-daemon` acts as a client of
  other daemons, handing off sessions over Noise-IK encrypted TCP to deploy
  work elsewhere.

Client/server communication is encoded via [Postcard](https://postcard.jamesmunns.com/).

## Threading model

The daemon uses **pure OS threads with message passing** (actor model) — no
async code in its own logic, and no `Arc<Mutex>` shared state. All I/O uses
blocking `std` APIs on dedicated threads:

```
main()
├── listener thread — UnixListener accept loop
│   └── per client: spawns client_thread
├── metrics HTTP thread — (optional) serves /metrics
├── command thread — DaemonCommand receiver loop
│   └── owns DaemonState (exclusive access)
├── per-session threads — one per active session
│   └── owns SessionState (exclusive access)
└── main thread — polls shutdown flag, orchestrates exit
```

This keeps the mental model simple — each thread owns its data — and avoids the
complexity of async cancellation. Two crates drive async clients behind a tokio
sidecar runtime that the daemon calls through synchronous `execute_*` entry
points (which `block_on` internally): `choreo-coord` (always linked, uses
`subxt` for the Coordination Platform chain) and the optional
`choreo-blockchain` (the alloy/subxt EVM + Substrate tools, linked only with
the `blockchain` feature).

## Request flow

```
RunInput received
  └► validate session, check active requests
     └► tool-call loop (daemon-wide cap, default 0 = unlimited):
        1. build system content (skills + context, fingerprint-cached)
        2. send messages + tools → model
        3. receive response
        4. if tool_call → execute tool → repeat
        5. else → emit final text, Done
```

Concurrent tools are dispatched across multiple OS threads in parallel;
session-config tools (`load_tools`, `unload_tools`, `set_working_dir`) run
serially to preserve ordering.

## Workspace topology

Sixteen crates in a single Cargo workspace (resolver = "3"). The dependency
spine is `choreo-proto` → `choreo-keystore` / `choreo-transport`, with
`choreo-client-core` and the daemon on top, and clients (`choreo-tui`,
`choreo-gui`, `choreo-im`, `choreo-acp`) as leaves. The daemon itself also
acts as a client — `choreo-daemon` can connect to other daemons to handoff
sessions.

| Crate | Description |
|---|---|
| `choreo-daemon` | The core engine — binary `choreographr`. Unix socket server that validates credentials, manages persistent sessions (with sub-sessions and working directories), runs requests with a tool-call loop, and streams responses. Also connects to other daemons over Noise-IK to handoff sessions and deploy work elsewhere |
| `choreo-ai-protocols` | Provider protocols — OpenAI-compatible, Anthropic Messages, and Google Gemini clients, the `ProviderClient` trait, and the provider catalog (200+ providers) |
| `choreo-blockchain` | Blockchain tools — EVM (alloy) and Substrate/Polkadot (subxt) read-only queries plus the tokio sidecar runtime they run on; pulled in by the daemon's `blockchain` feature (off by default) |
| `choreo-coord` | Coordination Platform orchestration — composes the chain / indexer / IPFS pipelines for the `coord` tool group (always linked) |
| `choreo-image` | Image decode surface — raster decode with EXIF orientation baked in, HEIC decode (with a decompression-bomb guard), and SVG rasterization |
| `choreo-sanitize` | Shared string-safety leaf — output sanitization (control chars, truncation, fenced-output safety) used across tools |
| `choreo-proto` | Framed binary protocol (postcard + length prefix) shared between clients and daemon |
| `choreo-keystore` | X25519 keypair + ECDH/AES-256-GCM crypto library for encrypted credentials; also Substrate (Polkadot) account credentials and Polkadot-JS keyring import |
| `choreo-transport` | Noise-IK encrypted transport over TCP with message fragmentation and per-chunk locking |
| `choreo-mcp` | MCP (Model Context Protocol) client — spawns subprocess servers, discovers tools, dispatches calls over JSON-RPC stdio |
| `choreo-acp` | ACP (Agent Communication Protocol) bridge — translates JSON-RPC 2.0 over stdin/stdout into `choreo-proto` messages so ACP-compatible editors can drive sessions |
| `choreo-tui` | Full-screen terminal UI client (ratatui + crossterm) |
| `choreo-gui` | Desktop GUI client (Dioxus) |
| `choreo-im` | Instant messaging bridge (Telegram) |
| `choreo-client-core` | Shared parsing, markdown, image assembly, and daemon-message dispatch for UI clients |
| `choreo-markdown` | Markdown parser and HTML renderer (pulldown-cmark + ammonia) |

## Wire protocol

Client/daemon communication is a framed binary protocol (postcard + length
prefix), defined in `choreo-proto`. Remote connections are wrapped in the
Noise IK encrypted transport from `choreo-transport`. The protocol is
versioned (v3): streaming is **lossless** — each client has an unbounded
outbound queue with lag-based eviction, and an `Evicted` event informs a slow
client of dropped state instead of silently truncating a session. Session
history is compressed with zstd (schema 1→2 migration) so long-running
sessions stay compact on disk.

## Vision & browsing

- **Vision input** — `read_image` normalizes an image (resize / MIME /
  re-encode, EXIF orientation baked in) and hands the bytes to a vision-capable
  model; normalized bytes persist in the `session_attachments` table.
- **Web page rendering** — `retrieve_webpage` launches a one-shot headless
  Chromium/Chrome (run locally and offline) to capture HTML, text, screenshots,
  or PDFs.

## Coordination Platform

The `coord` tool group (always linked) drives the Choreographr Coordination
Platform through `choreo-coord`, which composes three pipelines: a Substrate
chain (subxt, `block_on` into a tokio sidecar), the `acuity-index` event
indexer, and a local IPFS daemon. Write tools sign extrinsics with the
keystore's Substrate account credential.

## Provider architecture

Three layers:

1. `ProviderClient` trait (`choreo-ai-protocols`) — the wire-protocol layer for
   OpenAI-compatible, Anthropic Messages, and Google Gemini clients.
2. `InferenceProvider` (`choreo-daemon`) — a protocol-erased facade wrapping an
   `Arc<dyn ProviderClient>` plus the catalog slug; records API metrics.
3. **Provider Catalog** (`choreo-ai-protocols/src/catalog/`) — one TOML file
   per provider with a curated model list, context windows, and reasoning
   levels. Adding a provider is a data-file edit, not code.
