+++
title = "FAQ"
description = "Frequently asked questions about Choreographr."
weight = 14

# Single source of truth for the visible Q&A (rendered by page.html) and the
# FAQPage JSON-LD structured data. Keep questions in `q` and answers in `a`
# (markdown allowed in `a`).
[extra]
[[extra.faq]]
q = "What is Choreographr?"
a = "Choreographr is an all-purpose, extensible AI agent system written entirely in Rust. It has a client/server architecture and can run many sessions simultaneously. It runs locally or in the cloud, and LLM-generated code can be executed in a sandboxed RISC-V VM for complete security and observability."

[[extra.faq]]
q = "What can I use it for?"
a = "Software development, a personal/business agent, or research. It runs on your desktop or in the cloud, and you can talk to it from the terminal, a desktop app, or your phone (via the Telegram bridge)."

[[extra.faq]]
q = "Which models does it support?"
a = "70+ providers across three wire protocols: OpenAI-compatible (OpenAI, DeepSeek, Mistral, xAI, Groq, Ollama, OpenRouter, and many more), Anthropic Messages (Claude and friends), and Google Gemini."

[[extra.faq]]
q = "Is my data private?"
a = "Choreographr is local-first. Sessions and credentials live on your machine (encrypted at rest), and you choose which model providers your prompts go to. The daemon starts locked and credentials are only decrypted into memory after unlock."

[[extra.faq]]
q = "Is LLM-generated code safe to run?"
a = "Generated code runs in an isolated RISC-V VM by default, which is a complete replacement for the shell tool — full control and observability. OS-level sandboxing for tools that must run outside the VM is on the roadmap."

[[extra.faq]]
q = "Does it require an async runtime?"
a = "No — the daemon uses pure OS threads with message passing. No async code in its own logic, no `Arc<Mutex>` shared state. The one exception is the optional `blockchain` feature: the `choreo-blockchain` crate holds a tokio sidecar runtime for its async alloy/subxt clients, and the daemon calls into it through synchronous `execute_*` entry points. Without that feature, tokio isn't linked at all."

[[extra.faq]]
q = "Can it talk to blockchains?"
a = "Yes — the `blockchain` tool group adds read-only EVM and Substrate/Polkadot tools (balances, blocks, transactions, contract calls, ENS, storage queries). It's compiled in when the daemon is built with the `blockchain` cargo feature (enabled in the release binaries) and activated per session with `load_tools blockchain`. See the [tools reference](@/docs/tools.md#blockchain-tools)."

[[extra.faq]]
q = "Is it open source?"
a = "Yes — Apache-2.0."

[[extra.faq]]
q = "What's the minimum supported Rust version?"
a = "1.91."

[[extra.faq]]
q = "What else do I need to build it?"
a = "A **Zig 0.16.0** toolchain in addition to Rust. The [`zlob`](https://crates.io/crates/zlob) dependency — a fast globbing and file-walking library written in Zig — is compiled from Zig source at build time, so `zig` must be on your `PATH`. Choreographr uses zlob for the glob matching and gitignore-aware walking behind the `find` and `grep` tools."

[[extra.faq]]
q = "How is Choreographr different from other agents?"
a = "Its daemon + multi-client architecture, sandboxed RISC-V VM, subsessions (hierarchical subagents), and per-session undo/redo are a distinctive combination. See the [comparison](@/_index.md) on the homepage."
+++
