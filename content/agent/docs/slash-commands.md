+++
title = "Slash commands"
description = "The complete /command reference for choreo-tui."
weight = 5
+++

All commands in `choreo-tui` use the `/` prefix.

## Sessions

| Command | Description |
|---|---|
| `/session` | Show current session info |
| `/session list` | List all sessions |
| `/session new [title]` | Create a new session |
| `/session switch <id>` | Switch to a different session |
| `/session info <id>` | Show info for a specific session |

## Models & accounts

| Command | Description |
|---|---|
| `/models` | List and select models |
| `/model` | Alias for `/models` |
| `/account list` | List configured AI provider accounts |
| `/account remove <name>` | Remove an AI provider account |
| `/account <name>` | Set the session's AI provider account |
| `Ctrl+M` | Open the model selector popup (kitty keyboard protocol required) |

`Ctrl+A` opens the accounts page — list accounts, remove with `r`, set an API
key with `c`, or start the new-account wizard with `n`. The wizard is a
two-phase flow: pick a provider, then enter a slug.

## Reasoning

| Command | Description |
|---|---|
| `/reasoning` | Show current reasoning effort slug |
| `/reasoning <slug>` | Set reasoning effort (e.g. `off`, `low`, `medium`, `high`, `on`, `xhigh`, `max`) |
| `Ctrl+R` | Cycle reasoning effort through available slugs for the attached model |

## Lifecycle & editing

| Command | Description |
|---|---|
| `/ping` | Health check |
| `/cancel <request-id>` | Cancel a running request |
| `/stop` | Cancel whatever request is active on the attached session |
| `/continue` | Continue a stopped/idle session ("Please continue.") |
| `/undo` | Undo the most recent user turn and its entire assistant response subtree |
| `/redo` | Redo the most recently undone turn |
| `/unlock [passphrase]` | Unlock the daemon (reads `identity.pk` or decrypts `identity.pk.enc`) |
| `/lock` | Lock the daemon, clearing credentials from memory |

## Credentials

| Command | Description |
|---|---|
| `/add-key <service> <api_key> [unlock]` | Add an API key credential |
| `/add-x <service> <key> <secret> <token> <token_secret> [bearer] [unlock]` | Add an X credential |
| `/remove-key <service>` | Remove a credential |

Any other input is sent to the attached session as a prompt. In `choreo-tui`,
`Ctrl+C` exits the local client and disconnects from the daemon without
requesting daemon shutdown.
