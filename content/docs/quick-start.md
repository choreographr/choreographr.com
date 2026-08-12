+++
title = "Quick start"
description = "Run your first conversation with Choreographr."
weight = 2
+++

Choreographr is installed as two binaries: `choreographr` (the daemon) and
`choreo-tui` (the terminal client). If you haven't installed them yet, see
[Installation](@/docs/installation.md).

## 1. Start the daemon

```bash
choreographr                  # default log level: info
choreographr -v               # debug
choreographr -vv              # trace
choreographr -q               # warnings only
```

`RUST_LOG` takes precedence over the CLI flags:

```bash
RUST_LOG=debug choreographr
```

## 2. Attach a client

Open a new terminal tab and run the TUI:

```bash
choreo-tui
```

## Your first conversation

Accounts are managed right in the TUI — no config files needed.

1. Press `Ctrl+A` to open the **accounts** page.
2. Press `n` to start a new account.
3. Select a provider and press `Enter`.
4. Enter a custom name for the account and press `Enter`.
5. Paste the API credential and press `Enter`.
6. Press `Esc` (or `q`) to go back to the chat.
7. Select the account with `/account <name>`.
8. Press `Ctrl+M` to select the model.
9. Press `Ctrl+R` to select the reasoning effort.
10. Send your first prompt!

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
[Terminal client](@/docs/terminal.md) page for details.
