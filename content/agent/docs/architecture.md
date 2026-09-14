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

![Architecture diagram: server with TUI, GUI and server clients, model providers, and the RISC-V VM sandbox](/architecture.svg)

- The client can run on the same computer as the daemon (via a local Unix
  socket), or the daemon can live anywhere on your local network or the
  Internet.
- `choreo-tui` starts a local daemon automatically when it cannot reach one.
- When connecting remotely, clients use **Noise** encrypted TCP — **IK**
  against a pinned server key, **XX** first-contact mode otherwise.
- Daemons will also be able to connect to each other — acting as a client of
  another daemon to hand off sessions over Noise encrypted TCP and deploy work
  elsewhere (planned; not yet implemented).

Client/server communication is encoded with [MessagePack](https://msgpack.org/)
(named mode, via `rmp-serde`).

## Threading model

The daemon uses **pure OS threads with message passing** (actor model) — no
async code in its own logic, and shared mutable state kept to a few deliberate,
localized exceptions rather than being the design's backbone. All I/O uses
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
complexity of async cancellation. The optional `choreo-blockchain` crate drives
async clients (alloy/subxt for the EVM + Substrate tools) behind a tokio
sidecar runtime that the daemon calls through synchronous `execute_*` entry
points (which `block_on` internally); it is linked only with the `blockchain`
feature. The daemon also runs a platform **power-events** monitor thread
(suspend/resume, `choreo-power-events`) and tracks live provider sockets in
`choreo-sockreg`, so a cancel or a system sleep can force-close a wedged
connection.

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

Eighteen crates in a single Cargo workspace (resolver = "3"). The two
foundational crates — `choreo-proto` (the wire format) and `choreo-keystore`
(credentials) — have no workspace dependencies; `choreo-transport` builds on
`choreo-proto`, and `choreo-client-core` and the daemon sit on top, with the
clients and bridges (`choreo-tui`, `choreo-gui`, `choreo-im`, `choreo-acp`,
`choreo-mcp`) as leaves.

| Crate | Description |
|---|---|
| `choreo-daemon` | The core engine — binary `choreographr`. Unix socket server that validates credentials, manages persistent sessions (with sub-sessions and working directories), runs requests with a tool-call loop, and streams responses. Daemon-to-daemon session hand-off is planned but not yet implemented |
| `choreo-ai-protocols` | Provider protocols — OpenAI-compatible, Anthropic Messages, and Google Gemini clients, the `ProviderClient` trait, the image-generation adapters, and the provider catalog (200+ providers) |
| `choreo-blockchain` | Blockchain tools — EVM (alloy) and Substrate/Polkadot (subxt) read-only queries plus the tokio sidecar runtime they run on; pulled in by the daemon's `blockchain` feature (off by default) |
| `choreo-content` | Coordination Platform client — Substrate chain writes (subxt via a tokio sidecar), indexer reads, IPFS add/cat, and content encode/decode; pulled in by the daemon's `content` feature (off by default) |
| `choreo-image` | Image decode surface — raster decode with EXIF orientation baked in, HEIC decode (with a decompression-bomb guard), and SVG rasterization |
| `choreo-sanitize` | Shared string-safety leaf — output sanitization (control chars, truncation, fenced-output safety) used across tools |
| `choreo-proto` | Framed binary protocol (MessagePack + length prefix) shared between clients and daemon |
| `choreo-keystore` | X25519 keypair + ECDH/AES-256-GCM crypto library for encrypted credentials, the per-daemon keystore binding, and shared config paths |
| `choreo-transport` | Noise encrypted transport over TCP (IK + XX first-contact) with message fragmentation and per-chunk locking |
| `choreo-sockreg` | Live-socket registry — tracks provider connections (by fd) so the daemon can force-close a wedged reader on cancel or sleep, plus TCP keepalive tuning |
| `choreo-power-events` | Platform suspend/resume notifications (Linux logind / macOS IORegisterForSystemPower) delivered as channel events |
| `choreo-tui` | Full-screen terminal UI client (ratatui + crossterm) |
| `choreo-gui` | Desktop GUI client (Dioxus) |
| `choreo-im` | Instant-messaging bridge (Telegram, with more platforms planned) — chat with your agent on the go; its own binary, not part of the prebuilt releases (`cargo build -p choreo-im`) |
| `choreo-acp` | ACP bridge — translates the Agent Communication Protocol (JSON-RPC over stdin/stdout) into daemon messages so ACP-compatible editors (Claude Code, Cline, …) can drive sessions; its own binary (`cargo build -p choreo-acp`) |
| `choreo-mcp` | MCP (Model Context Protocol) client — spawns subprocess servers, discovers their tools, and dispatches calls over JSON-RPC stdio; library-only, linked via the daemon's `mcp` feature (off by default) |
| `choreo-client-core` | Shared parsing, markdown, image assembly, and daemon-message dispatch for UI clients |
| `choreo-markdown` | Markdown parser and HTML renderer (pulldown-cmark + ammonia) |

## Wire protocol

Client/daemon communication is a framed binary protocol (MessagePack + length
prefix), defined in `choreo-proto`. Remote connections are wrapped in the
Noise encrypted transport from `choreo-transport` (IK against a pinned server
key; XX first-contact mode on the wire v5 handshake). The protocol is
versioned: streaming is **lossless** — each client has an unbounded outbound
queue with lag-based eviction, and an `Evicted` event informs a slow client of
dropped state instead of silently truncating a session. Session history is
compressed with zstd (schema 1→2 migration) so long-running sessions stay
compact on disk.

## Vision & browsing

- **Vision input** — `read_image` normalizes an image (resize / MIME /
  re-encode, EXIF orientation baked in) and hands the bytes to a vision-capable
  model; normalized bytes persist in the `session_attachments` table.
- **Web page rendering** — `retrieve_webpage` launches a one-shot headless
  Chromium/Chrome (run locally and offline) to capture HTML, text, screenshots,
  or PDFs.
- **Image generation** — `generate_image` produces a new image from a text
  prompt through the session's image-capable provider and feeds it through the
  same display/persistence pipeline as `display_image`.

## Provider architecture

Three layers:

1. `ProviderClient` trait (`choreo-ai-protocols`) — the wire-protocol layer for
   OpenAI-compatible, Anthropic Messages, and Google Gemini clients.
2. `InferenceProvider` (`choreo-daemon`) — a protocol-erased facade wrapping an
   `Arc<dyn ProviderClient>` plus the catalog slug; records API metrics.
3. **Provider Catalog** (`choreo-ai-protocols/src/catalog/`) — a normalized
   [models.dev](https://models.dev) snapshot of provider/model information
   (context windows, reasoning levels, output limits, modalities), layered with
   a bundled `models-overlay.toml` policy file and an optional user overlay at
   `~/.config/choreographr/models-overlay.toml`. Adding or overriding a provider
   is a data edit, not code — see
   [Accounts & providers](@/agent/docs/accounts-and-providers.md).
