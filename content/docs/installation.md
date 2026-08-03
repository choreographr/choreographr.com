+++
title = "Installation"
description = "Building the workspace, running the binaries, and the crate layout."
weight = 2
+++

## Building from source

Requires a Rust toolchain with MSRV **1.91** or newer.

```bash
cargo build --release
```

The workspace uses Cargo resolver version 3 and consists of twelve crates. Run
the daemon and clients with `cargo run --release -p <crate>`.

## Crate layout

| Crate | Description |
|---|---|
| `choreo-daemon` | The core engine — binary `choreographr`. Unix socket server that validates credentials, manages persistent sessions (with sub-sessions and working directories), runs requests with a tool-call loop, and streams responses |
| `choreo-ai-protocols` | Provider protocols — OpenAI-compatible, Anthropic Messages, and Google Gemini clients, the `ProviderClient` trait, and the provider catalog (70+ providers) |
| `choreo-proto` | Framed binary protocol (postcard + length prefix) shared between clients and daemon |
| `choreo-keystore` | X25519 keypair + ECDH/AES-256-GCM crypto library for encrypted credentials |
| `choreo-transport` | Noise-IK encrypted transport over TCP |
| `choreo-mcp` | MCP (Model Context Protocol) client — spawns subprocess servers, discovers tools, dispatches calls over JSON-RPC stdio |
| `choreo-acp` | ACP (Agent Communication Protocol) bridge — translates JSON-RPC 2.0 over stdin/stdout into `choreo-proto` messages so ACP-compatible editors can drive sessions |
| `choreo-tui` | Full-screen terminal UI client (ratatui + crossterm) |
| `choreo-gui` | Desktop GUI client (Dioxus) |
| `choreo-im` | Instant messaging bridge (Telegram) |
| `choreo-client-core` | Shared parsing, markdown, image assembly, and daemon-message dispatch for UI clients |
| `choreo-markdown` | Markdown parser and HTML renderer (pulldown-cmark + ammonia) |

## Client/server architecture

Choreographr separates the server software that runs sessions from the clients
that connect and disconnect at any time.

- The client can run on the same computer as the daemon (via a local Unix
  socket), or the daemon can live anywhere on your local network or the
  Internet.
- When connecting remotely, clients use **Noise-IK** encrypted TCP.
- Because the daemon can live anywhere and is reachable over encrypted TCP, it
  can also be reached from mobile devices — for example, chatting with your
  agent on the go via the `choreo-im` Telegram bridge.

Client/server communication is encoded via [Postcard](https://postcard.jamesmunns.com/).
