+++
title = "Quick start"
description = "Build Choreographr from source and run your first conversation."
weight = 1
+++

Choreographr requires a [Rust toolchain](https://rustup.rs/) — the minimum supported
Rust version (MSRV) is **1.91**.

## 1. Build

```bash
rustup install stable
cargo build --release
```

## 2. Start the daemon

```bash
cargo run --release -p choreo-daemon         # default log level: info
cargo run --release -p choreo-daemon -- -v   # debug
cargo run --release -p choreo-daemon -- -vv  # trace
cargo run --release -p choreo-daemon -- -q   # warnings only
```

`RUST_LOG` takes precedence over the CLI flags:

```bash
RUST_LOG=debug cargo run --release -p choreo-daemon
```

## 3. Attach a client

```bash
cargo run --release -p choreo-tui     # terminal UI
cargo run --release -p choreo-gui     # desktop app
cargo run --release -p choreo-im      # IM bridge
cargo run --release -p choreo-acp     # ACP bridge for editors
```

## Your first conversation

1. **Configure an account** in `~/.config/choreographr/accounts.toml` (see
   [Accounts & providers](@/docs/accounts-and-providers.md)) and add an API key
   with `/add-key <service> <api_key>`.
2. Select the account with `/account <name>`.
3. Start prompting!

```
┌──────────────┐   Unix socket /     ┌──────────────┐   HTTP/SSE     ┌────────────────────┐
│  choreo-tui  │◄───────────────────►│              │◄──────────────►│  OpenAI-compatible │
│  (terminal)  │                     │              │                ├────────────────────┤
├──────────────┤                     │              │◄──────────────►│  Anthropic Messages│
│  choreo-gui  │◄───────────────────►│ choreographr │                ├────────────────────┤
│  (desktop)   │   Noise-IK TCP      │  (daemon)    │◄──────────────►│  Google Gemini     │
├──────────────┤                     │              │                └────────────────────┘
│  choreo-im   │◄───────────────────►│              │
│  (IM bridge) │                     │              │
├──────────────┤                     │              │
│ choreo-acp   │◄───────────────────►│              │   MCP subprocess servers
│  (ACP bridge)│                     └──────────────┘   RISC-V VM sandbox
└──────────────┘                                        redb database
```

That's it — you're chatting with your agent.
