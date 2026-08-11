+++
title = "Choreographr v0.1.0 Released"
description = "An all-purpose, extensible AI agent written in Rust — daemon + multi-client, a sandboxed RISC-V VM, and 70+ model providers."
date = 2026-08-11
template = "blog-page.html"
# Top-level `authors` feeds the Atom feed; the `[taxonomies] authors` below
# drives the author pages/byline. Kept in sync.
authors = ["Jonathan Brown"]
[taxonomies]
tags = ["announcement", "rust"]
authors = ["Jonathan Brown"]
+++

I've spent the past two months working on a new AI agent called Choreographr and the first version has just been released.

So why make another agent? We already have very successful agents such as Codex, Claude Code, OpenCode, Pi, Openclaw, Hermes, and many more.

There are a few things that Choreographr does differently:

## Rust

Many agents are written in JavaScript or Python and are starting to show the limits of what an agent written in these languages can do.

Choreographr has:

- **no async code in core components** — it is built with real threads that communicate via messaging, and each session runs in its own thread. The optional blockchain tools run on a small tokio sidecar; everything else is thread-only.
- **high CPU efficiency** — agents are inherently I/O bound and don't really need much CPU, but agents in other languages use a lot of CPU, wasting laptop battery, heating up your laptop and causing fans to produce noise. Choreographr is so CPU efficient you will not notice it. Your software builds, of course, are another story.
- **high RAM efficiency** — other agents consume a huge amount of RAM. Choreographr is extremely lean.
- **robustness** — Rust's memory safety makes a long-lived daemon that holds your API keys and runs untrusted model output a much safer proposition.

Check out our [Why Rust?](@/docs/why-rust.md) page for more information.

## Client / Server

Most agents are a single process with a single UI. Choreographr is built the
other way around: a **daemon** owns your sessions, and clients connect and
disconnect whenever they want.

- **`choreo-tui`** — a full-screen terminal UI with O(1) scrolling and streaming.
- **`choreo-gui`** — a desktop app (Dioxus), in development.
- **`choreo-im`** — chat with your agent from Telegram.
- **`choreo-acp`** — drive sessions from ACP-compatible editors like Claude Code.

Because sessions live in the daemon, you can start a task in the terminal and
check on it from your phone. Everything persists in an embedded `redb`
database and survives restarts.

![Choreographr architecture: clients (TUI, GUI, IM, ACP) and the daemon handoff connect to the choreographr daemon, which talks to model providers and runs MCP servers, a RISC-V VM sandbox, and a redb database](/architecture.svg)

## RISC-V VM

Anyone who has used a coding agent knows the value of giving an LLM access to a terminal. It can do anything, but this configuration is not for everyone. Only developers and power users really understand what the LLM is doing in a shell, and even then it can be hard to track.

AI agents have huge use cases beyond coding. Research agents, personal agents, and business agents will all be used extensively by non-developers. In this situation, giving the LLM access to the shell is a recipe for disaster, no matter the safeguards put in place. It can find a way to do anything, and there is no log of what has happened.

A virtual machine is a much better environment for an LLM to run in. It is secure by design rather than bolted on later. Rather than issuing tool calls at the end of each turn, the LLM can quickly write a script (for example in Rust) that gets compiled to RISC-V. The script then makes tool calls as necessary (including subsessions), but not shell calls. Every tool call is logged, so there is no ambiguity about what the LLM has done.

In the future, RISC-V programs can be saved to run later or on a schedule via cron.

## Concurrent Sessions

The server can run an arbitrary number of sessions concurrently, taking full advantage of multithreading, rather than having a single async process managing everything. Sessions can invoke multiple "subsessions" via a tool call. Sessions will also be able to be handed off to other agents via inter-agent communication.

## Encrypted credentials

Credentials for LLMs and other cloud services are encrypted at rest. The decryption key is only provided by the client as necessary.

## Agent DB

A key/value database is exposed directly to the agent, so LLMs can store data persistently.

## Blockchain Native

Choreographr has native tool calling for **Ethereum (EVM)** and **Polkadot (Substrate)** blockchains, behind the optional `blockchain` feature (enabled in the release binaries). From any session you can read balances, inspect blocks and transactions, make read-only contract calls, resolve ENS names, and query Substrate storage. Solana support is on the roadmap.

This is important for a number of reasons:

- Using AI to read and write to the blockchain is incredibly powerful. For example, a DeFi trading bot.
- Agent coordination — currently agents collaborate via centralized entities such as GitHub, but this is proving unreliable.
- Existing on-chain publishing technologies such as my other project [Acuity](https://acuity.network) are a perfect fit for agents.

It will be possible to pay for model access with cryptocurrencies directly in the TUI/GUI.

## What's next

Subsessions (hierarchical subagents) already exist. Next up, each session will
be able to work on its own git branch in its own worktree, so parallel
subsessions can work on the same codebase without colliding. Cron,
extensions, and OS-level sandboxing are also on the roadmap.

Ready to give it a spin? See the [installation guide](@/docs/installation.md)
and [quick start](@/docs/quick-start.md).

We'd love your help — star the [repo](https://github.com/choreographr/choreographr),
open [issues](https://github.com/choreographr/choreographr/issues), and join
the [Telegram community](https://t.me/choreographr).
