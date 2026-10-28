+++
title = "Quick start"
description = "Run your first conversation with Choreographr."
weight = 2
+++

Choreographr is installed as two binaries: `choreographr` (the daemon) and
`choreo-tui` (the terminal client). If you haven't installed them yet, see
[Installation](@/agent/docs/installation.md).

## 1. Start the daemon

In Unix-socket mode you usually don't need to start the daemon yourself: when
`choreo-tui` can't reach a daemon, it **starts one for you** — spawning a
detached child with `--auto-exit`, so it shuts down again when the last client
disconnects. Run the daemon manually when you want full control over its
lifetime and logs:

```bash
choreographr                  # default log level: info
choreographr -v               # debug
choreographr -vv              # trace
choreographr -q               # warnings only
```

CLI flags take precedence over `RUST_LOG` (use `RUST_LOG` for a finer
per-target filter):

```bash
RUST_LOG=debug choreographr
```

## 2. Attach a client

Open a new terminal tab and run the TUI:

```bash
choreo-tui
```

## Your first conversation

Accounts are managed right in the TUI — no config files needed. An empty session
shows a **welcome checklist** that ticks itself off as you go:

1. **Add an account** — press `Alt+A` to open the accounts page, then `n` to
   start the new-account wizard. Pick a provider (type to filter; the common ones
   are listed first), keep the suggested account name or type your own, and paste
   the API credential.

   A provider that signs in with OAuth instead of an API key (for example
   `chatgpt`) takes no key: create the account, then run `/login <account>` —
   add `--device` on a remote or SSH host.

2. **Use it in this session** — automatic when the session has no account yet:
   as soon as the daemon confirms the credential, the TUI selects the account for
   you. Otherwise select the account on the `Alt+A` page and press `Enter`, or run
   `/account <name>`.

3. **Choose a model** — the picker opens for you after step 2 (`Alt+M` opens it
   any time). The list fills in as soon as the daemon has the account's models.

Press `Alt+R` to pick a reasoning effort if the model supports it, then send your
first prompt.

That's it — you're chatting with your agent.

## See an image inline

The agent can display images right in the terminal. Ask it to show a diagram
or a chart:

```
you: render the architecture diagram as an image
```

When the agent calls `display_image`, the image appears **inline in the chat
history** — PNG, JPEG, or vector SVG (SVG is rasterized at display resolution,
so diagrams stay crisp). Click the image for a fullscreen view; press `Esc` to
dismiss. Images render via the kitty graphics protocol or sixel where
supported, with a universal fallback that works in any terminal. See the
[Terminal client](@/agent/docs/terminal.md) page for details.
