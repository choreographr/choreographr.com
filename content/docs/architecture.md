+++
title = "Architecture"
description = "Threading model, workspace topology, and where to find the deep dive."
weight = 9
+++

The full architecture deep-dive lives in the repository at `ARCHITECTURE.md`.
This page is a short orientation.

## Threading model

The daemon uses **pure OS threads with message passing** (actor model) — no
async code in its own logic, and no `Arc<Mutex>` shared state. All I/O uses
blocking `std` APIs on dedicated threads:

```
main()
├── listener thread — UnixListener accept loop
│   └── per client: spawns client_thread
├── metrics HTTP thread — (optional) serves /metrics
├── command thread — DaemonCommand receiver loop
│   └── owns DaemonState (exclusive access)
├── per-session threads — one per active session
│   └── owns SessionState (exclusive access)
└── main thread — polls shutdown flag, orchestrates exit
```

This keeps the mental model simple — each thread owns its data — and avoids the
complexity of async cancellation. A global tokio runtime exists only as a
sidecar for crates (e.g. alloy) that require it.

## Request flow

```
RunInput received
  └► validate session, check active requests
     └► tool-call loop (daemon-wide cap, default 0 = unlimited):
        1. build system content (skills + context, fingerprint-cached)
        2. send messages + tools → model
        3. receive response
        4. if tool_call → execute tool → repeat
        5. else → emit final text, Done
```

Concurrent tools are dispatched across multiple OS threads in parallel;
session-config tools (`load_tools`, `unload_tools`, `set_working_dir`) run
serially to preserve ordering.

## Workspace topology

Twelve crates in a single Cargo workspace (resolver = "3"). See
[Installation](@/docs/installation.md) for the crate table. The dependency
spine is `choreo-proto` → `choreo-keystore` / `choreo-transport`, with
`choreo-client-core` and the daemon on top, and clients (`choreo-tui`,
`choreo-gui`, `choreo-im`, `choreo-acp`) as leaves.

## Wire protocol

Client/daemon communication is a framed binary protocol (postcard + length
prefix), defined in `choreo-proto`. Remote connections are wrapped in the
Noise IK encrypted transport from `choreo-transport`.

## Provider architecture

Three layers:

1. `ProviderClient` trait (`choreo-ai-protocols`) — the wire-protocol layer for
   OpenAI-compatible, Anthropic Messages, and Google Gemini clients.
2. `InferenceProvider` (`choreo-daemon`) — a protocol-erased facade wrapping an
   `Arc<dyn ProviderClient>` plus the catalog slug; records API metrics.
3. **Provider Catalog** (`choreo-ai-protocols/src/catalog/`) — one TOML file
   per provider with a curated model list, context windows, and reasoning
   levels. Adding a provider is a data-file edit, not code.
