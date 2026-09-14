+++
title = "Terminal client"
description = "What choreo-tui renders: markdown, syntax highlighting, inline images, streaming, and O(1) scrolling."
weight = 5
+++

`choreo-tui` is the terminal client. It attaches to a daemon over the local
Unix socket — or over TCP with a Noise handshake (`--tcp-addr` / `--server-pk`;
IK when the server's key is pinned, XX on first contact) — and renders your
sessions in a full-screen UI. If no local daemon is reachable it **starts one
automatically** (see the [quick start](@/agent/docs/quick-start.md)). It is
entirely event driven and runs fullscreen: the terminal updates the moment a
keystroke or network event arrives, with no maximum framerate. Scrolling and
streaming are O(1), so history stays smooth even on very long sessions.

## What the TUI renders

- **Markdown** — headings, lists, code blocks, tables, links, blockquotes,
  emphasis, inline code, and LaTeX math rendered as pretty Unicode, all wrapped
  to the terminal width.
- **Syntax highlighting** — code in tool output is highlighted with syntect
  themes.
- **Images** — when the agent calls `display_image` (PNG, JPEG, or SVG) — or
  generates one with `generate_image` — the image appears **inline in the chat
  history** at half the viewport height. Click an image to open it fullscreen;
  press `Esc` to dismiss.
- **Status bar** — the attached session's account slug, model, reasoning effort,
  and live token estimates. A session that is not idle is marked, and the client
  refuses to submit a new prompt until it is idle again (rejected text stays in
  the input bar).
- **Tool results** — streaming execution descriptions, collapsible per-result
  bodies, and live token estimates in the status bar.
- **Selection & copy** — drag with the mouse to select text in the history pane
  and copy it via OSC 52 (a cross-terminal clipboard escape). Selection follows
  the cursor while scrolling, stays anchored to the text mid-gesture, and is
  copied as unwrapped text.
- **Per-session drafts** — an unsent prompt is kept per session, so switching
  sessions and returning preserves what you were typing; `Ctrl+Backspace` clears
  the draft.

## Image rendering

Image encoding runs on a **background thread** so the UI never stalls, and
results are cached per terminal size — switching between the inline view and
fullscreen never re-encodes. SVG is rasterized at display resolution with
system fonts loaded, so vector diagrams stay crisp at any terminal size.

The terminal protocol is auto-detected at startup and falls back gracefully:

| Protocol | Where it works |
|---|---|
| Kitty graphics | kitty, foot, wezterm, ghostty, and other kitty-graphics terminals |
| Sixel | terminals with sixel support (e.g. xterm-sixel, mlterm) |
| Universal fallback | any other terminal |

## Managing sessions

- `Ctrl+S` — session manager: list, switch, create, and delete sessions
- `Ctrl+A` — accounts page: add, remove, and select AI provider accounts
- `Ctrl+M` — model selector (falls back to `Ctrl+O` on terminals without the
  kitty keyboard protocol)
- `Ctrl+R` — cycle the reasoning effort
- `Ctrl+H` — toggle the keybinding help overlay
- `Ctrl+Q` — quit the client

The full command reference lives on the
[slash commands](@/agent/docs/slash-commands.md) page.
