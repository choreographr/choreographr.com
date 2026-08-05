+++
title = "Troubleshooting"
description = "Diagnostics, logs, and common problems."
weight = 13
+++

## Logs

- `choreo-tui` writes its diagnostics to `/tmp/choreo-tui.log` — check there for
  client-side issues.
- The daemon logs to stderr; use `-v`/`-vv` for more detail, or set
  `RUST_LOG` (which takes precedence over the CLI flags).

## Common issues

**The daemon won't accept prompts**
The daemon starts locked and credentials are only decrypted after `/unlock`.
If a request fails with a locked error, run `/unlock [passphrase]` and make
sure a credential exists for the session's account (`/add-key <service>
<api_key>`).

**No model responds**
Check that the session has an account set (`/account <name>`) and that the
account name matches an entry in `~/.config/choreographr/accounts.toml`.
Account names must match `[a-z0-9_-]`.

**Provider errors on a custom gateway**
Override the base URL per-account in `accounts.toml`:

```toml
[[account]]
name = "local"
provider = "ollama"
base_url = "http://localhost:11434/v1"
```

**Remote clients can't connect**
Remote connections use the Noise IK handshake; make sure the daemon is
listening on TCP (see `choreo-gui`'s `--tcp-addr` / `--server-pk` flags) and
that the client has the server's public key.

## Getting help

Ask in the [Telegram community](https://t.me/choreographr), or open an issue
on [GitHub](https://github.com/ethernomad/choreographr).
