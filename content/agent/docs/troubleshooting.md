+++
title = "Troubleshooting"
description = "Diagnostics, logs, and common problems."
weight = 13
+++

## Logs

- `choreo-tui` writes its diagnostics to
  `$XDG_STATE_HOME/choreographr/tui-<pid>.log` (falling back to the platform temp
  directory) — check there for client-side issues.
- The daemon logs to stderr; use `-v`/`-vv` for more detail (CLI flags take
  precedence over `RUST_LOG`). A TUI-autostarted daemon logs to a per-process
  file (`$XDG_STATE_HOME/choreographr/daemon-<pid>.log`, else the temp dir); pass
  `--log-file <path>` to write logs elsewhere when starting it yourself.

## Common issues

**The daemon won't accept prompts**
The daemon starts locked and credentials are only decrypted after `/unlock`.
If a request fails with a locked error, run `/unlock` (it uses the daemon's
stored key) and make sure a credential exists for the session's account
(`/add-key <service> <api_key>`).

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
Remote connections use a Noise handshake — XX on first contact, then IK against
the pinned key. Make sure the daemon is listening on TCP (see `choreo-tui`'s
`--tcp-addr` / `--server-pk` flags), confirm the server fingerprint on first
connect, and check that the client is in the daemon's `authorized_clients.toml`
allow-list (enroll a local client with `/acl add`).

**No daemon is running**
In Unix-socket mode `choreo-tui` starts a daemon automatically when it cannot
reach one, and shows a status message while the daemon starts. If that fails,
run `choreographr` in another terminal and inspect
`$XDG_STATE_HOME/choreographr/daemon-<pid>.log`. A daemon that is already
listening at the
socket path is reported explicitly rather than being replaced.

## Getting help

Ask in the [Telegram community](https://t.me/choreographr), or open an issue
on [GitHub](https://github.com/choreographr/choreographr).
