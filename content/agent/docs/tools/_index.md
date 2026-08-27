+++
title = "Tools"
description = "The complete reference for every built-in tool and tool group."
weight = 7
sort_by = "weight"
+++

Tools are the functions the LLM — and the RISC-V VM — can call to interact
with the outside world: reading and writing files, running shell commands,
making HTTP requests, managing Git repositories, querying a persistent
database, reading images into a vision model, browsing the web, posting to X,
publishing to the Choreographr Coordination Platform, and more. This section
is the complete reference: how tools work, how they are grouped, and what each
one does.

- **[Core tools](@/agent/docs/tools/core.md)** — files, search, HTTP & images,
  vision input, web-page rendering, PDFs, and orchestration.
- **[Git tools](@/agent/docs/tools/git.md)** — status, diff, log, add, commit,
  push, show.
- **[Shell tools](@/agent/docs/tools/shell.md)** — `exec`, `sh`, `nushell`, `fish`.
- **[Database tools](@/agent/docs/tools/databases.md)** — the session-scoped
  `redb` key-value store.
- **[X (Twitter) tools](@/agent/docs/tools/x.md)** — post, search, user lookup.
- **[Blockchain tools](@/agent/docs/tools/blockchain.md)** — EVM and
  Substrate/Polkadot read-only queries.
- **[Coordination Platform tools](@/agent/docs/tools/coordination.md)** — the
  on-chain publishing and coordination platform.
- **[Diagnostic tools](@/agent/docs/tools/diagnostics.md)** — `session_inspect`.
- **[RISC-V VM tool](@/agent/docs/tools/riscv.md)** — `run_riscv`.
- **[MCP servers](@/agent/docs/tools/mcp.md)** — dynamic groups from MCP servers.

## How tools work

Every tool implements the `Tool` trait (name, group, description, JSON Schema,
and `execute`) and is registered in a `ToolRegistry` at daemon startup. Before
each model call, the daemon advertises the JSON Schemas of the tools in the
session's **active groups**; the model can call any of them, and the daemon
executes the call and returns the result. The JSON Schema *is* the interface —
the model learns exactly what arguments each tool expects.

### Tool call lifecycle

1. The model emits a tool call: a name plus arguments as JSON.
2. The daemon validates the arguments against the tool's schema and executes
   the tool with the session's working directory and credentials.
3. Streaming tools (`sh`, `exec`, `find`, `grep`, `run_series`, `run_riscv`)
   deliver output in chunks as it is produced; other tools return their result
   in the next turn append.
4. The result is appended to the conversation and the agent loop continues.

Every tool also produces a human-readable **invocation description**
(e.g. "Reading `src/main.rs`.") that the client displays while the call runs,
and tools with structured return types expose an `output_schema` for
[programmatic tool calling](https://developers.openai.com/api/docs/guides/tools-programmatic-tool-calling)
(Responses API, gpt-5.6+ models).

## Tool groups

Tools are organized into **groups** to keep the model's context small. Only
**`core`**, **`git`**, **`shell`**, and **`coord`** are active by default. The
model can activate additional groups with `load_tools` and deactivate them with
`unload_tools`; `core` is always active and cannot be unloaded.

> Groups are a **discovery mechanism, not access control** — the RISC-V VM
> always has access to all tools.

| Group | Description | Active by default |
|---|---|---|
| `core` | Filesystem, HTTP, images, display, PDF, web page rendering, vision (read_image), search, random, time, sessions, series | ✅ always |
| `git` | Local Git operations (status, diff, log, add, commit, push, show) | ✅ |
| `shell` | Shell execution (bash, nushell, fish, exec) | ✅ |
| `coord` | Choreographr Coordination Platform (blockchain content registry + IPFS + indexer) | ✅ always |
| `db` | Session-scoped key-value database (redb) | — |
| `x` | X/Twitter API (post, search, user lookup) | — |
| `vm` | RISC-V sandboxed code execution | — |
| `debug` | Read-only diagnostics and request dry-runs (`session_inspect`) | — |
| `blockchain` | EVM and Substrate/Polkadot blockchain queries (alloy/subxt) | — |
| `mcp/<server>` | One dynamic group per configured MCP server | — |

> The `coord` group is **always compiled in and active by default**, like
> `core`, `git`, and `shell` — the Coordination Platform tools need no feature
> flag. The `blockchain` group exists only when the daemon is built with the
> `blockchain` cargo feature (the release binaries enable it). The tools live
> in the `choreo-blockchain` crate, which also owns the tokio sidecar runtime
> the alloy/subxt clients run on.

Activate a group from the model side:

```json
{ "name": "load_tools", "arguments": { "groups": ["db", "x"] } }
```

and deactivate it with `unload_tools`. Groups can also be passed to
`spawn_subsession` via its `categories` argument so a subsession starts with
exactly the tools it needs.

## Security model

- **Groups are discovery, not access control.** Loading `git` or `shell` just
  adds tool definitions to the model's context; it does not enforce what the
  model may do. The VM always has access to all tools.
- **Callers.** Tools declare which callers may invoke them (`Direct` — the
  model — and/or `Programmatic` — a VM guest). Session-config mutations like
  `set_working_dir`, `load_tools`, and `unload_tools` are model-only, so a VM
  program cannot silently redirect the session mid-task.
- **Credentials.** Tools that need them (X, model APIs) pull credentials from
  the encrypted keystore — never from prompt context.
