+++
title = "Why Rust?"
description = "Why Rust is a fantastic choice for writing an AI agent and its terminal UI."
weight = 8
+++

Rust is not the most common language for AI agents today — most agent
frameworks are written in TypeScript or Python, and for good reasons those
languages make sense in many contexts. But Choreographr is written entirely in
Rust, and this page explains why that is a deliberate, structural choice rather
than a stylistic one: for an *agent that must run for a long time, hold your
credentials, execute untrusted code, and stay responsive across many
simultaneous sessions*, Rust's properties line up almost exactly with what the
job demands.

## A daemon you can trust with your keys

An agent is not a script — it is a **long-lived daemon** that holds API keys,
writes to your filesystem, runs shell commands, and talks to the network. The
worst failure mode is a memory-safety bug that lets a crafted model response or
a misbehaving tool corrupt memory. In Rust, that entire class of bug is
*impossible by construction*: no null pointer dereferences, no use-after-free,
no buffer overflows, no data races — the compiler rejects them at build time.

This is not theoretical. Choreographr encrypts every credential at rest with
X25519/ECDH + AES-256-GCM, stores keys in a keystore that zeroizes secrets from
memory on lock, and exposes them only to the daemon process. Memory safety is
the foundation that makes it reasonable to concentrate that much trust in one
process.

## Concurrency without async complexity

Agents are inherently concurrent: many sessions running at once, tool calls
executing in parallel, streaming output being fanned out to connected clients.
Most modern agent codebases reach for an async runtime to handle this — and
then spend enormous effort debugging the state that async code shares.

Choreographr does something simpler. The daemon uses **pure OS threads with
message passing** — an actor model, in the classic sense:

- each session runs on its own thread and *owns* its state;
- threads communicate only through typed channels (`mpsc`);
- there is no `Arc<Mutex>` shared state anywhere in the daemon's own logic.

This is only feasible because the Rust compiler *enforces* it: you cannot move
a piece of state into two threads, or share it without synchronization, without
the borrow checker stopping you. The result is a threading model you can hold
in your head — each thread owns its data, period — with none of the
cancellation and `Send`-bound complexity that async runtimes impose. When a
third-party library insists on async (the alloy and subxt clients behind the
optional `blockchain` feature), a tokio runtime exists as a sidecar inside the
`choreo-blockchain` crate; the daemon itself never needs one.

## The compiler as your agent-loop auditor

The heart of an agent is the **tool-calling loop**: send the conversation to
the model, execute whatever tools it requests, feed the results back, repeat
until the model produces a final answer. An LLM's output is untrusted,
semi-structured, and frequently malformed — truncated JSON, dropped tool calls,
unexpected event types.

Rust turns this hostile input into a *compile-time contract*. The streaming
response is parsed into a typed enum (`TextDelta`, `FunctionCallArgumentsDone`,
`ResponseCompleted`, …) and the agent loop `match`es on it exhaustively:

- a new event type added upstream is a **compile error** until the loop decides
  what to do with it — it can never be silently ignored;
- a required field missing from a model event is a **hard, classified error**,
  not a silently-`null`ed default that confuses the next turn;
- the result of each turn is a typed enum (`FinalText` vs `ToolUse`), and
  `#[non_exhaustive]` forces every consumer to keep thinking about future
  variants.

The LLM will always produce weird output. In Rust, "weird" is a type you have
to handle — not a crash waiting to happen.

## Types that become the wire protocol

Agents are glued together with JSON: tool definitions, tool-call arguments,
provider APIs, streaming events. Every boundary where data crosses a wire or a
process is a place where types can silently diverge from reality.

In Choreographr, a tool's JSON Schema is **auto-derived from its Rust types**
via `schemars`. You declare:

```rust
struct ReadFileArgs {
    path: String,
    offset: Option<u32>,
}
```

…and you get the advertised schema, the argument deserialization, and
compile-time field access for free. The schema sent to the model can *never*
drift from the types the tool actually parses, because they are the same thing.
The same philosophy extends to the client/daemon protocol, which is a framed
binary format with typed message enums instead of ad-hoc JSON.

## Security by construction — and a sandbox that is real

An agent that can run arbitrary LLM-generated code needs a hard boundary.
Choreographr's answer is the **RISC-V VM**: the model writes a small Rust
snippet, it is compiled to a RISC-V ELF, and executed inside an isolated VM
with its own flat memory — no host syscalls, no host memory, no filesystem
access except through registered tools.

Rust is the natural host for this for two reasons. First, the tool ABI the
guest calls into is the same typed `ToolRegistry` the host uses, so the
sandbox's surface is defined by types, not by string conventions. Second, the
VM's own tooling — compilation of guest code, bytecode loading, memory
management — is memory-safe by construction, which is exactly what you want in
the security-critical component.

## A TUI that stays smooth under load

Agents stream. Token by token, reasoning and answers flow into the terminal,
and the UI must keep up without stuttering or stealing CPU from the model
calls. Choreographr's TUI is **event-driven and immediate mode**: it redraws
the instant a keystroke or network event arrives, with no maximum framerate,
no polling, and O(1) scrolling and streaming.

Rust's performance makes this trivial, and its ownership model makes
the render/event split safe: the renderer never mutates state, so drawing and
input handling can't race.

