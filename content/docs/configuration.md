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

## Environment variables

| Variable | Purpose |
|---|---|
| `CHOREOGRAPHR_SOCKET_PATH` | Override the Unix socket path (default `/tmp/Choreographr.sock`) |
| `CHOREOGRAPHR_DB_PATH` | Override the database path (default `~/.local/share/choreographr/state.redb`) |
| `CHOREOGRAPHR_MAX_TURNS` | Override `max_turns` (resolution chain: env → config.toml → default `0`) |
| `RUST_LOG` | Log level (takes precedence over `-v`/`-vv`/`-q` flags) |

A `max_turns` value of `0` means **unlimited** — the agent loop runs until the
model produces a final answer, is cancelled, or hits an error. This is a
daemon-wide cap; individual sessions do not carry their own `max_turns`.

## Identity keys

Identity keys live in `~/.config/choreographr/`:

- `identity.pk` — the private key
- `public.pk` — the public key
- `identity.pk.enc` — optional passphrase-encrypted private key

Credentials are encrypted per-credential with the daemon's X25519 public key and
stored in the `redb` database. See [Security](@/docs/security.md) for details.

## Slash command reference

See the [Slash commands](@/docs/slash-commands.md) page for the full list of
commands available in `choreo-tui`.
