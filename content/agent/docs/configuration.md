+++
title = "Configuration"
description = "config.toml, environment variables, paths, and the security model for keys."
weight = 3
+++

The daemon reads config from `~/.config/choreographr/config.toml`. All fields
are optional.

```toml
max_turns = 0      # daemon-wide tool-loop budget; 0 = unlimited (default)

[context]
context_file_names = ["AGENTS.md", "CLAUDE.md"]
context_file_max_bytes = 32768
disable_claude_code_prompt = false
```

> **Note:** Provider-level settings (`base_url`, `streaming`, `retry_*`,
> timeouts, endpoint paths, request format, etc.) have moved to per-account
> overrides in `accounts.toml`. They are no longer read from `config.toml`.
>
> `accounts.toml` is **watched live**: edits are picked up without a restart,
> and affected sessions rebuild their provider clients on the next request.

## Environment variables

| Variable | Purpose |
|---|---|
| `CHOREOGRAPHR_SOCKET_PATH` | Override the Unix socket path (default: the platform temp directory, e.g. `$TMPDIR/Choreographr.sock`) |
| `CHOREOGRAPHR_DB_PATH` | Override the database path (default `~/.local/share/choreographr/state.redb`) |
| `CHOREOGRAPHR_MAX_TURNS` | Override `max_turns` (resolution chain: env → config.toml → default `0`) |
| `RUST_LOG` | Log level (overridden by explicit `-v`/`-vv`/`-q` flags) |

A `max_turns` value of `0` means **unlimited** — the agent loop runs until the
model produces a final answer, is cancelled, or hits an error. This is a
daemon-wide cap; individual sessions do not carry their own `max_turns`.

## Transport keys

The machine's transport keys and trust state live in
`~/.config/choreographr/`:

- `transport.sec` — the Noise IK static secret key (32-byte X25519)
- `transport.pub` — the matching static public key; peers identify this machine
  by it, and `choreographr fingerprint` renders it
- `known_servers.toml` — pinned server fingerprints for remote connections
- `authorized_clients.toml` — the daemon's client allow-list

Credentials are encrypted per-credential with the daemon's X25519 public key and
stored in the `redb` database. The daemon binds its keystore once; thereafter
`/unlock` uses the stored per-daemon unlock key. See
[Security](@/agent/docs/security.md) for details.

## Daemon flags

| Flag | Purpose |
|---|---|
| `-v` / `-vv` / `-q` | Log verbosity (debug / trace / warnings); takes precedence over `RUST_LOG` |
| `--log-file <path>` | Write daemon logs to a file instead of stderr (ANSI disabled) |
| `--auto-exit` | Shut down gracefully when the last client disconnects |
| `--metrics-addr <addr>` | Serve an OpenMetrics endpoint (see [Monitoring](@/agent/docs/monitoring.md)) |

## Slash command reference

See the [Slash commands](@/agent/docs/slash-commands.md) page for the full list of
commands available in `choreo-tui`.
