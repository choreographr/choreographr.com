+++
title = "Choreographr v0.1.0 Released"
description = "Choreographr v0.1.0 is out — an open-source (Apache-2.0) AI agent in Rust with a sandboxed RISC-V VM, a persistent daemon, and 70+ model providers."
date = 2026-08-11
template = "blog-page.html"
# Top-level `authors` feeds the Atom feed; the `[taxonomies] authors` below
# drives the author pages/byline. Kept in sync.
authors = ["Jonathan Brown"]
[taxonomies]
tags = ["announcement", "rust"]
authors = ["Jonathan Brown"]
+++

AI agents are moving into the terminal — and that is exactly the problem. An
LLM with shell access can do almost anything, which is precisely why only
careful power users feel comfortable handing it the keys. And even then, most
agents feel disposable: one process you close, a wall of RAM and fan noise, no
real record of what the model actually did.

Choreographr is built to run for months, not minutes. A **persistent daemon**
owns your sessions while clients — terminal, desktop, Telegram, editor — come
and go. LLM-generated code runs in a **sandboxed RISC-V VM** instead of your
shell. And the core is written in **Rust**, so it stays lean, memory-safe, and
honest about everything the agent did. The first release, v0.1.0, is out now.

> [!TIP]
> **Try it now — no Rust toolchain needed.** Prebuilt binaries ship for macOS
> (Apple Silicon) and Linux x86_64 as Homebrew, `.deb`/`.rpm`, and static
> tarballs. Then it's two commands to your first conversation:

```bash
brew tap choreographr/choreographr
brew install choreographr
choreographr   # terminal 1 — the daemon
choreo-tui     # terminal 2 — the terminal client
```

See the [installation guide](@/docs/installation.md) for every platform, and
the [quick start](@/docs/quick-start.md) for your first prompt.

## So why another agent?

There are already very good agents — Codex, Claude Code, OpenCode, Pi,
Openclaw, Hermes, and more. Choreographr exists because three things matter
that few agents deliver together:

- **Safety by design** — model output runs in a sandboxed VM, not an unlogged
  shell, and every tool call is recorded.
- **A daemon that owns your sessions** — clients come and go; start a task in
  the terminal and check on it from your phone.
- **A core that can be trusted to run for months** — Rust: memory-safe by
  construction, and light enough on CPU and RAM that you stop noticing it.

The rest of this post digs into those three, and there's a
[feature-by-feature comparison](/) on the homepage if you want the table view.

## A sandbox, not a shell

The most dangerous thing you can give an agent is a shell. It can do anything —
and for anyone who isn't a careful power user, that is a recipe for disaster,
no matter the safeguards. You can't easily see what the model is doing, and
there is no reliable log of what it has done.

Choreographr replaces the shell with a **RISC-V virtual machine**. Instead of
issuing tool calls at the end of each turn, the model writes a small script (in
Rust, compiled to RISC-V) that runs inside an isolated VM with its own flat
memory: no host syscalls, no host filesystem access, no raw shell. Every tool
call the guest makes is dispatched through the same typed `ToolRegistry` the
host agent uses — including subsessions — and every call is logged. Secure by
design rather than bolted on, and fully observable.

## One daemon, every surface

Most agents are a single process with a single UI. Choreographr is built the
other way around: one **daemon** owns your sessions, and clients connect and
disconnect whenever they want.

- **`choreo-tui`** — a full-screen terminal UI with O(1) scrolling and
  streaming, markdown rendering, syntax highlighting, and a model selector.
- **`choreo-gui`** — a desktop app (Dioxus), in development.
- **`choreo-im`** — chat with your agent on the go, from Telegram.
- **`choreo-acp`** — drive sessions from ACP-compatible editors like Claude
  Code and Cline.

Because sessions live in the daemon, you can start a task in the terminal and
check on it from your phone. Everything persists in an embedded `redb` database
and survives restarts.

<!-- TODO: add a choreo-tui screenshot here (ideally with a short screencast of
streaming and a run_riscv call) once available -->

![Choreographr architecture: clients (TUI, GUI, IM, ACP) and the daemon handoff connect to the choreographr daemon, which talks to model providers and runs MCP servers, a RISC-V VM sandbox, and a redb database](/architecture.svg)

## Rust, because it has to last

Most agents are written in JavaScript or Python — and it shows, both in how
much CPU and RAM they burn and in what it means to run one for weeks while it
holds your API keys. Choreographr's core is pure Rust for three reasons:

- **Memory safety by construction** — no null dereferences, use-after-free, or
  buffer overflows; the compiler rejects them before they exist. A long-lived
  daemon that holds your keys and runs untrusted model output should not be one
  segfault away from a problem.
- **Threads, not async** — the daemon uses real OS threads with message
  passing; each session owns its state, with none of the shared-state and
  cancellation complexity an async runtime brings.
- **Lean enough to ignore** — agents are I/O bound, and Choreographr stays
  light on CPU and RAM so you barely notice it's running. Your builds, of
  course, are another story. <!-- TODO: add real measured numbers here (idle RSS, CPU while streaming) when available -->

The [Why Rust?](@/docs/why-rust.md) page goes into the details.

## Blockchain native

Choreographr has **native tool calling for Ethereum (EVM) and Polkadot
(Substrate)**, compiled into the release binaries. From any session you can
read balances, inspect blocks and transactions, make read-only contract calls,
resolve ENS names, and query Substrate storage — see the
[blockchain tools](@/docs/tools.md#blockchain-tools) reference. Solana support
is on the roadmap.

Why this matters:

- Using AI to read and write the blockchain is incredibly powerful — a DeFi
  trading bot, for example.
- Agent coordination: today agents collaborate through centralized services
  like GitHub, which is proving unreliable. On-chain coordination is the
  natural next step.
- Existing on-chain publishing technologies, like my other project
  [Acuity](https://acuity.network), are a perfect fit for agents.

It will also be possible to pay for model access with cryptocurrency directly
in the TUI/GUI.

## And everything else

The rest of the feature list in brief:

- **70+ model providers** — OpenAI, Anthropic, Mistral, DeepSeek, xAI, Groq,
  Ollama, OpenRouter and more, via OpenAI-compatible, Anthropic Messages, and
  Gemini APIs.
- **Concurrent sessions & subsessions** — the daemon runs many sessions in
  parallel on real threads, and any session can spawn hierarchical subsessions
  through a tool call.
- **Encrypted credentials** — every key is encrypted at rest with X25519 ECDH +
  AES-256-GCM; the daemon starts locked and decrypts in memory only after
  unlock. See [security](@/docs/security.md).
- **Agent database** — a persistent, session-scoped key-value store (`redb`)
  the agent writes to and reads back. See
  [database tools](@/docs/tools.md#database-tools).
- **MCP client** — spawn Model Context Protocol servers, discover their tools,
  and call them from any session.
- **ACP bridge** — drive sessions from ACP-compatible editors like Claude Code
  and Cline.
- **Undo/redo per session** — if the agent mis-steps, remove the prompt instead
  of prompting more.

## What's next

Subsessions already exist; here's what's on the roadmap:

- **Git worktrees** — each subsession works on its own branch, so parallel
  agents can share a codebase without colliding.
- **Cron** — save RISC-V programs and run them on a schedule.
- **Extensions** — hook into the server over a local socket to add tools and
  plugins.
- **OS-level sandboxing** — Landlock on Linux, Seatbelt on macOS, for tools
  that must run outside the VM.
- **Inter-daemon handoff** — pass sessions between daemons over Noise.

Ready to give it a spin? The [quick start](@/docs/quick-start.md) gets you to
your first prompt, and the
[release notes](https://github.com/choreographr/choreographr/releases) cover
what's in v0.1.0.

We'd love your help — star the
[repo](https://github.com/choreographr/choreographr), open
[issues](https://github.com/choreographr/choreographr/issues), and join the
[Telegram community](https://t.me/choreographr).
