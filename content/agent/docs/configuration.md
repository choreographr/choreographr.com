+++
title = "Configuration"
description = "config.toml, environment variables, paths, and the security model for keys."
weight = 3
+++

The daemon reads config from `$XDG_CONFIG_HOME/choreographr/config.toml` (i.e.
`~/.config/choreographr/config.toml` on most systems). All fields are optional.

```toml
max_turns = 0      # daemon-wide tool-loop budget; 0 = unlimited (default)

[context]
context_file_names = ["AGENTS.md", "CLAUDE.md"]
context_file_max_bytes = 32768
disable_claude_code_prompt = false

[cache_warming]              # prompt-cache warming — off by default (see below)
mode = "off"                 # off | streaming (warm the cache while a tool call blocks)
min_prefix_tokens = 32000    # `tokens`-metered gate: minimum cacheable prefix, in tokens
min_expected_savings = 0.05  # `payg`-metered gate: minimum USD saved per ping
```

> **Note:** Provider-level settings (`base_url`, `streaming`, `retry_*`,
> timeouts, endpoint paths, request format, etc.) have moved to per-account
> overrides in `accounts.toml`. They are no longer read from `config.toml`.
>
> `accounts.toml` is **watched live**: edits are picked up without a restart,
> and affected sessions rebuild their provider clients on the next request.
> MCP servers live in a separate `mcp.json` (see the
> [tools reference](@/agent/docs/tools/_index.md#mcp-servers)).

## Prompt-cache warming

A warm ping re-sends the last request with a one-token output cap to refresh the
provider's prompt cache before its TTL expires. It is **off by default** and
only pays off under some billing plans, so it is gated per account by a `meter`:
`payg` and `tokens` accounts warm when the saving clears a threshold, while
`requests`, `flat`, and `unknown` never do (a ping burns quota). Set
`mode = "streaming"` — globally in `[cache_warming]`, or per account in
`accounts.toml` — and a `meter` to opt in.

## Environment variables

| Variable | Purpose |
|---|---|
| `CHOREOGRAPHR_SOCKET_PATH` | Override the Unix socket path (default `$XDG_RUNTIME_DIR/choreographr.sock`, or `/tmp/choreographr.sock` when no runtime dir is available) |
| `CHOREOGRAPHR_DB_PATH` | Override the database path (default `$XDG_DATA_HOME/choreographr/state.redb`, i.e. `~/.local/share/choreographr/state.redb`) |
| `CHOREOGRAPHR_MAX_TURNS` | Override `max_turns` (resolution chain: env → config.toml → default `0`) |
| `CHOREOGRAPHR_BASE_DIR` | Relocate the whole instance under one root (same as `--base-dir`) |
| `RUST_LOG` | Log level (overridden by explicit `-v`/`-vv`/`-q` flags) |

A `max_turns` value of `0` means **unlimited** — the agent loop runs until the
model produces a final answer, is cancelled, or hits an error. This is a
daemon-wide cap; individual sessions do not carry their own `max_turns`.

## Transport keys

Paths resolve through the **XDG** directories by default — config in
`$XDG_CONFIG_HOME/choreographr/`, data in `$XDG_DATA_HOME/choreographr/`, the
socket in `$XDG_RUNTIME_DIR`, and logs in `$XDG_STATE_HOME/choreographr/`. Pass
`--base-dir <PATH>` (or set `CHOREOGRAPHR_BASE_DIR`) to relocate the whole
instance under one root instead; `choreographr migrate --base-dir <PATH>` copies
an existing install across (preserving the keystore, so clients keep their
pinned server key).

The machine's transport keys and trust state live in the config directory:

- `transport.sec` — the Noise IK static secret key (32-byte X25519)
- `transport.pub` — the matching static public key; peers identify this machine
  by it, and `choreographr fingerprint` renders it
- `known_servers.toml` — pinned server fingerprints for remote connections
- `authorized_clients.toml` — the daemon's client allow-list
- `mcp.json` — daemon-wide MCP servers (see the [tools reference](@/agent/docs/tools/_index.md)); a project's `.mcp.json` is gated behind trust stored in `trust.toml`

Credentials are encrypted per-credential with the daemon's X25519 public key and
stored in the `redb` database. The daemon binds its keystore once; thereafter
`/unlock` uses the stored per-daemon unlock key. See
[Security](@/agent/docs/security.md) for details.

## Logs

Every binary writes its own **pid-keyed log file** —
`$XDG_STATE_HOME/choreographr/<binary>-<pid>.log` (e.g. `tui-4242.log`), or
`{base}/log/...` under `--base-dir`, else the platform temp dir. The daemon and
the IM bridge also mirror to stderr; the GUI and ACP adapter mirror only when
attached to a terminal. `--log-file <path>` overrides the destination.

Log files are owner-only, pruned by **age** (one week), and never contain
payloads: prompts, model output, tool arguments and results, and credentials are
recorded as ids, kinds, lengths, and counts. Use `-v`/`-vv`/`-q` (which take
precedence over `RUST_LOG`) to change what is recorded.

## Daemon flags

| Flag | Purpose |
|---|---|
| `-v` / `-vv` / `-q` | Log verbosity (debug / trace / warnings); takes precedence over `RUST_LOG` |
| `--log-file <path>` | Write daemon logs to a file instead of stderr (ANSI disabled) |
| `--auto-exit` | Shut down gracefully when the last client disconnects |
| `--base-dir <PATH>` | Relocate the whole instance (config, data, socket, logs) under one root |
| `--metrics-addr <addr>` | Serve an OpenMetrics endpoint (see [Monitoring](@/agent/docs/monitoring.md)) |

## Slash command reference

See the [Slash commands](@/agent/docs/slash-commands.md) page for the full list of
commands available in `choreo-tui`.
