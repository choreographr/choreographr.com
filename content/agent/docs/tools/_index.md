+++
title = "Tools"
description = "The complete reference for every built-in tool and tool group."
weight = 7
sort_by = "weight"
+++

Tools are the functions the LLM — and the RISC-V VM — can call to interact
with the outside world: reading and writing files, running shell commands,
making HTTP requests, managing Git repositories, querying a persistent
database, reading images into a vision model, browsing the web, generating and
editing images, posting to X, and more. This section
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
- **[Image tools](@/agent/docs/tools/image.md)** — `generate_image`
  (text-to-image) and `edit_image` (image-to-image).
- **[Diagnostic tools](@/agent/docs/tools/diagnostics.md)** — `session_inspect`.
- **[RISC-V VM tool](@/agent/docs/tools/riscv.md)** — `run_riscv`.

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
**`core`**, **`git`**, and **`shell`** are active by default. The
model can activate additional groups with `load_tools` and deactivate them with
`unload_tools`; `core` is always active and cannot be unloaded.

> Groups are a **discovery mechanism, not access control** — the RISC-V VM
> always has access to all tools.

| Group | Description | Active by default |
|---|---|---|
| `core` | Filesystem, HTTP, images, display, PDF, web page rendering, vision (read_image), search, random, time, sessions, series | ✅ always |
| `git` | Local Git operations (status, diff, log, add, commit, push, show) | ✅ |
| `shell` | Shell execution (bash, nushell, fish, exec) | ✅ |
| `image` | Image generation and editing (`generate_image`, `edit_image`) | — |
| `db` | Session-scoped key-value database (redb) | — |
| `x` | X/Twitter API (post, search, user lookup) | — |
| `vm` | RISC-V sandboxed code execution | — |
| `debug` | Read-only diagnostics and request dry-runs (`session_inspect`) | — |
| `mcp/<slug>` | Tools exposed by a configured MCP server (one group per server) | — |
| `blockchain` | EVM and Substrate/Polkadot blockchain queries (alloy/subxt) | — |

> The `image` group holds `generate_image` and `edit_image` — both need an
> account whose provider supports image generation (see
> [Accounts & providers](@/agent/docs/accounts-and-providers.md)). The
> `mcp` groups are named per server (`mcp/<slug>`) and are loaded like any
> other group. The
> `blockchain` group exists only when the daemon is built with the
> `blockchain` cargo feature (the release binaries enable it). The tools live
> in the `choreo-blockchain` crate, which also owns the tokio sidecar runtime
> the alloy/subxt clients run on.

## MCP servers

Choreographr is an **MCP (Model Context Protocol) client**, built on the
official [`rmcp`](https://crates.io/crates/rmcp) SDK. Each server's tools are
exposed under an `mcp/<slug>` group — activate one with `load_tools` (MCP
support is compiled into the default release binaries).

Servers are configured in two tiers:

- **Daemon tier** — `mcp.json` in the config directory, visible to every session.
- **Project tier** — a `.mcp.json` at the project root (found by walking up from
a session's working directory). Its servers are **gated behind trust**: they are
read but never spawned until you run `/mcp trust`.

Each entry is a named server under `mcpServers`. A stdio server sets `command`
(plus optional `args`/`env`/`cwd`); a remote server sets `url` (plus optional
`headers`), using the **Streamable HTTP** transport:

```json
{
  "mcpServers": {
    "docs": { "command": "npx", "args": ["-y", "@modelcontextprotocol/server-docs"] },
    "remote": { "url": "https://example.com/mcp", "headers": { "Authorization": "Bearer ${TOKEN}" } }
  }
}
```

Manage them with the `choreographr mcp` CLI (`list`, `add`, `remove`,
`reconnect`, `reload`) or the in-TUI `/mcp` commands (see
[Slash commands](@/agent/docs/slash-commands.md#mcp-servers)). A server that
changes its tool list refreshes the daemon's catalogue live, with no restart.
Activate a server's tools with `load_tools ["mcp/<slug>"]`.

A server that needs credentials takes a static token in `headers`, or an
interactive OAuth sign-in. Declare the latter with an `oauth` block — all fields
optional:

```json
{
  "mcpServers": {
    "shopify": {
      "url": "https://example.com/mcp",
      "oauth": {
        "clientId": "<app-client-id>",
        "authorizationServer": "https://auth.example.com",
        "clientSecretEnv": "SHOPIFY_MCP_SECRET",
        "scopes": ["mcp.read"]
      }
    }
  }
}
```

`clientSecretEnv` names an **environment variable** holding a confidential
client's secret — never the secret itself, which must not sit in a
repo-controlled file. `authorizationServer` names the issuer when the resource's
well-known paths do not carry it. Then run `/mcp login <slug>`, and `/mcp logout
<slug>` to drop the grant; `/mcp` shows each server's auth state. A project
server's `oauth` block is repo-controlled, so signing in for it is refused while
that project root is untrusted, and a stored grant whose issuer or resource no
longer matches is treated as absent.

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
