+++
title = "Quick start"
description = "Build Choreographr from source and run your first conversation."
weight = 1
+++

Choreographr requires a [Rust toolchain](https://rustup.rs/) — the minimum supported
Rust version (MSRV) is **1.91**.

## 1. Check out the project from GitHub

```bash
git clone https://github.com/ethernomad/choreographr
cd choreographr
```

## 2. Build

```bash
rustup install stable
cargo build --release
```

## 3. Start the daemon

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

## 4. Attach a client

Open a new terminal tab and run the TUI:

```bash
cargo run --release -p choreo-tui
```

## Your first conversation

Accounts are managed right in the TUI — no config files needed.

1. Press `Ctrl+A` to open the **accounts** page.
2. Press `n` to start a new account.
3. Select a provider and press `Enter`.
4. Enter a custom name for the account and press `Enter`.
5. Paste the API credential and press `Enter`.
6. Press `Esc` (or `q`) to go back to the chat.
7. Select the account with `/account <name>`.
8. Press `Ctrl+M` to select the model.
9. Press `Ctrl+R` to select the reasoning effort.
10. Send your first prompt!

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
