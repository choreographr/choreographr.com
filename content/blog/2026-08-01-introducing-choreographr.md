+++
title = "Introducing Choreographr"
description = "An all-purpose, extensible AI agent written in Rust — daemon + multi-client, a sandboxed RISC-V VM, and 70+ model providers."
date = 2026-08-01
template = "blog-page.html"
[taxonomies]
tag = ["announcement", "rust"]
+++

Choreographr is an all-purpose, extensible AI agent system written entirely in
Rust. It's early, it's open source (Apache-2.0), and it takes a few opinions
that we think are worth sharing.

## One daemon, many clients

Most agents are a single process with a single UI. Choreographr is built the
other way around: a **daemon** owns your sessions, and clients connect and
disconnect whenever they want.

- **`choreo-tui`** — a full-screen terminal UI with O(1) scrolling and streaming.
- **`choreo-gui`** — a desktop app (Dioxus), in development.
- **`choreo-im`** — chat with your agent from Telegram, in development.
- **`choreo-acp`** — drive sessions from ACP-compatible editors like Claude Code.

Because sessions live in the daemon, you can start a task in the terminal and
check on it from your phone. Everything persists in an embedded `redb`
database and survives restarts.

## LLM-generated code runs in a sandbox

Giving an agent direct shell access is one of the riskiest things you can do.
Choreographr offers a different default: generated code is compiled to RISC-V
and executed in an isolated VM with a 4&nbsp;MB flat memory space and a
configurable cycle budget. The guest can only interact with the world through
registered tools — same registry, same credentials, same working directory.

That VM is also a tool-call scripting language: the agent can quickly write a
little Rust snippet to orchestrate tools with custom logic.

## 70+ providers, one catalog

Choreographr speaks OpenAI-compatible, Anthropic Messages, and Google Gemini.
Each provider is a data file in a TOML catalog — curated models, context
windows, reasoning levels. Adding a new OpenAI-compatible provider is a data
edit, not a code change.

## High-performance by construction

The daemon uses pure OS threads and message passing — no async runtime, no
shared mutable state. Every thread owns its data. It's simple to reason about
and fast.

## What's next

Subsessions (hierarchical subagents) already exist; git worktrees, cron,
extensions, and OS-level sandboxing are on the roadmap. We'd love your help —
star the repo, open issues, and join the [Telegram community](https://t.me/choreographr).
