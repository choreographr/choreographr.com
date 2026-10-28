+++
title = "Slash commands"
description = "The complete /command reference for choreo-tui."
weight = 5
+++

All commands in `choreo-tui` use the `/` prefix. Typing `/` on an empty prompt
opens the **command palette** — `Enter` runs the highlighted command, `Tab`
completes the name, `↑`/`↓` move the selection, and `Esc` returns to the
prompt. The palette and the parser share one catalog, so what you see is what
runs.

## Sessions

| Command | Description |
|---|---|
| `/new [title]` | Create a session and switch to it |
| `/session` | Open the session manager (or `list`, `new [title]`, `switch <id>`, `info <id>`) |
| `/undo` | Undo the most recent user turn and its entire assistant response subtree |
| `/redo` | Redo the most recently undone turn |
| `/continue` | Continue a stopped/idle session ("Please continue.") |
| `/cancel <request-id>` | Cancel a request by id |
| `/stop` | Cancel whatever request is active on the attached session |
| `/ping` | Health check |

In the session manager (`Alt+S`), `Tab` toggles between the live and archived
lists, `p` pins or unpins a session (pinned sessions sort to the top), and `a`
archives or unarchives one.

## Models & accounts

| Command | Description |
|---|---|
| `/model [model]` | Choose the session's model (opens the picker when omitted) |
| `/account` | Open the accounts page (or `list`, `remove <name>`, `<name>` to set) |
| `/refresh-models [--force]` | Refresh the models.dev catalog |
| `/login <account> [--device]` | Sign in to an existing account's provider with OAuth (alias `/add-oauth`); `--device` selects the headless device-code flow |

`Alt+A` opens the accounts page — list accounts, remove with `r`, set an API
key with `c`, or start the new-account wizard with `n`.

## Reasoning

| Command | Description |
|---|---|
| `/reasoning` | Cycle the reasoning effort |
| `/reasoning list` | List the available reasoning levels |
| `/reasoning <level>` | Set reasoning effort (e.g. `off`, `low`, `medium`, `high`, `on`, `xhigh`, `max`) |

## Access control

| Command | Description |
|---|---|
| `/acl add <base64-pubkey>` | Enroll a client in the daemon's allow-list |

Client allow-listing is stored in `authorized_clients.toml` and hot-reloaded
from disk. See [Security](@/agent/docs/security.md#client-trust-access-control).

## MCP servers

| Command | Description |
|---|---|
| `/mcp` | Show every MCP server visible to the session (daemon + project tiers), with transport, auth state, connected state, tool count, or last error — plus the project root's trust state |
| `/mcp reconnect <slug>` | Rebuild every connection with that slug on the running daemon and refresh its tools |
| `/mcp reload` | Re-read the config on the running daemon — connect added servers, drop removed ones, rebuild changed ones — without a restart |
| `/mcp login <slug>` | Run a PKCE OAuth sign-in for a server that declares an `oauth` block; the grant is stored in the keystore and the server reconnects itself |
| `/mcp logout <slug>` | Remove that server's stored OAuth grant |
| `/mcp trust` | Trust the session's project MCP root so its servers connect |
| `/mcp untrust` | Revoke trust for that root; its project servers stop |
| `/mcp trust list` | List the trusted project roots |

Offline management lives in the `choreographr mcp` CLI (`list`, `add`,
`remove`, `reconnect`, `reload`). See the
[tools reference](@/agent/docs/tools/_index.md) for how MCP servers are
configured.

## Credentials

| Command | Description |
|---|---|
| `/add-key <service> <api_key>` | Store an API-key credential |
| `/add-x <service> <key> <secret> <token> <token_secret> <bearer>` | Store an X/Twitter credential |
| `/login <account>` | Sign in with OAuth instead of an API key (see [models & accounts](#models-accounts)) |
| `/remove-key <service>` | Remove a stored credential |

## Locking

| Command | Description |
|---|---|
| `/unlock [base64-key]` | Unlock the daemon — uses the stored per-daemon key, or records `key` on an already-bound daemon |
| `/lock` | Lock the daemon, clearing credentials from memory |

## Client

| Command | Description |
|---|---|
| `/quit` | Exit the TUI |

Any other input is sent to the attached session as a prompt. In `choreo-tui`,
`Ctrl+C` exits the local client and disconnects from the daemon without
requesting daemon shutdown.

## Keyboard shortcuts

Command shortcuts use `Alt+` — the `Ctrl+<letter>` space is reserved for
readline editing keys.

| Shortcut | Action |
|---|---|
| `Alt+A` | Accounts page |
| `Alt+S` | Session manager |
| `Alt+M` | Model selector |
| `Alt+R` | Cycle reasoning effort |
| `Alt+H` | Toggle the keybinding help overlay |
| `Alt+Up` / `Alt+Down` | Undo / redo |
| `Alt+Enter` | Continue |
| `Alt+Q` | Quit |
