+++
title = "Why Rust?"
description = "Why Rust is a fantastic choice for writing an AI agent and its terminal UI."
weight = 8
+++

Rust is not the most common language for AI agents today — most agent
frameworks are written in TypeScript or Python, and for good reasons those
languages make sense in many contexts. But Choreographr is written entirely in
Rust: for an *agent that must run for a long time, hold your credentials,
execute untrusted code, and stay responsive across many simultaneous sessions*,
Rust's properties line up almost exactly with what the job demands.

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
- threads communicate through typed `crossbeam` channels rather than shared
  mutable state;
- shared mutable state is the exception: a few deliberate, localized
  `Arc<Mutex<…>>` instances — the encrypted transport stream, the MCP client
  registry (on by default) — rather than the design's
  backbone.

This is only feasible because the Rust compiler *enforces* it: you cannot move
a piece of state into two threads, or share it without synchronization, without
the borrow checker stopping you. The result is a threading model that can be
reasoned about — each thread owns its data — with none of the cancellation and
`Send`-bound complexity that async runtimes impose. When a third-party library
insists on async — the alloy/subxt clients behind the optional `blockchain`
and `content` tools — a tokio runtime exists as a sidecar inside those crates
(`choreo-blockchain`, `choreo-content`); the daemon itself never needs one.

## Types that become the wire protocol

Agents are glued together with JSON: tool definitions, tool-call arguments,
provider APIs, streaming events. Every boundary where data crosses a wire or a
process is a place where types can silently diverge from reality.

In Choreographr, a tool's JSON Schema is **auto-derived from its Rust types**
via `schemars`. You declare:

```rust
struct ReadFileArgs {
    path: String,
    start_line: Option<u32>,
    max_lines: Option<u32>,
}
```

…and you get the advertised schema, the argument deserialization, and
compile-time field access for free. The schema sent to the model can *never*
drift from the types the tool actually parses, because they are the same thing.
The same philosophy extends to the client/daemon protocol, which is a framed
binary format with typed message enums instead of ad-hoc JSON.

## A sandbox for untrusted code

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

An active agent produces a constant stream of tokens — reasoning, answers, and
tool output — and several sessions may be doing so at once. The UI has to keep
up without stuttering or stealing CPU from the model calls. Choreographr's TUI
is **event-driven and fullscreen**: it redraws the instant a keystroke or
network event arrives — no polling loop, no maximum framerate — and both
scrolling and streaming are O(1), so even very long sessions stay smooth.

Rust is what makes that affordable. The UI runs a single event loop: one
thread handles keyboard input, daemon messages, and image-worker results —
merged with a `crossbeam` `select!` — and then draws, so input and rendering
are serialised by construction with no locks to contend on. When nothing has
changed the redraw is skipped, and while idle the thread blocks in the kernel
at zero CPU. The one genuinely expensive step — rasterising and encoding images
for the terminal — is handed to a background worker and comes back as just
another event.

