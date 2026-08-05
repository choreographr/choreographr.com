+++
title = "FAQ"
description = "Frequently asked questions about Choreographr."
weight = 14
+++

### What is Choreographr?

Choreographr is an all-purpose, extensible AI agent system written entirely in
Rust. It has a client/server architecture and can run many sessions
simultaneously. It runs locally or in the cloud, and LLM-generated code can be
executed in a sandboxed RISC-V VM for complete security and observability.

### What can I use it for?

Software development, a personal/business agent, or research. It runs on your
desktop or in the cloud, and you can talk to it from the terminal, a desktop
app, or your phone (via the Telegram bridge).

### Which models does it support?

70+ providers across three wire protocols: OpenAI-compatible (OpenAI, DeepSeek,
Mistral, xAI, Groq, Ollama, OpenRouter, and many more), Anthropic Messages
(Claude and friends), and Google Gemini.

### Is my data private?

Choreographr is local-first. Sessions and credentials live on your machine
(encrypted at rest), and you choose which model providers your prompts go to.
The daemon starts locked and credentials are only decrypted into memory after
unlock.

### Is LLM-generated code safe to run?

Generated code runs in an isolated RISC-V VM by default, which is a complete
replacement for the shell tool — full control and observability. OS-level
sandboxing for tools that must run outside the VM is on the roadmap.

### Does it require an async runtime?

No — the daemon uses pure OS threads with message passing. No async code in its
own logic, no `Arc<Mutex>` shared state. A tokio runtime exists only as a
sidecar for third-party crates that require it.

### Is it open source?

Yes — Apache-2.0.

### What's the minimum supported Rust version?

1.91.

### What else do I need to build it?

A [Zig](https://ziglang.org/) toolchain in addition to Rust — the build uses
Zig to compile the RISC-V VM components.

### How is Choreographr different from other agents?

Its daemon + multi-client architecture, sandboxed RISC-V VM, subsessions
(hierarchical subagents), and per-session undo/redo are a distinctive
combination. See the [comparison](@/_index.md) on the homepage.
