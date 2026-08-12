+++
title = "Terminal client"
description = "What choreo-tui renders: markdown, syntax highlighting, inline images, streaming, and O(1) scrolling."
weight = 5
+++

`choreo-tui` is the terminal client. It attaches to a running daemon over the
local Unix socket — or over TCP with a Noise IK handshake
(`--tcp-addr` / `--server-pk`) — and renders your sessions in a full-screen
UI. It is entirely event driven and runs in immediate mode: the terminal
updates the moment a keystroke or network event arrives, with no maximum
framerate. Scrolling and streaming are O(1), so history stays smooth even on
very long sessions.

## What the TUI renders

- **Markdown** — headings, lists, code blocks, tables, links, blockquotes,
  emphasis, inline code, and math, wrapped to the terminal width.
- **Syntax highlighting** — code in tool output is highlighted with syntect
  themes.
- **Images** — when the agent calls `display_image` (PNG, JPEG, or SVG), the
  image appears **inline in the chat history** at half the viewport height.
  Click an image to open it fullscreen; press `Esc` to dismiss.
- **Tool results** — streaming execution descriptions, collapsible per-result
  bodies, and live token estimates in the status bar.

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
| Half-blocks | any terminal — a 2-pixel-per-cell Unicode fallback |

Image blocks always reserve their height, so scrolling past an image stays
stable even while it is still encoding.

## Managing sessions

- `Ctrl+S` — session manager: list, switch, create, and delete sessions
- `Ctrl+A` — accounts page: add, remove, and select AI provider accounts
- `Ctrl+M` — model selector (requires a terminal with the kitty keyboard
  protocol; on other terminals `Ctrl+M` arrives as Enter)
- `Ctrl+R` — cycle the reasoning effort
- `Ctrl+H` — toggle the keybinding help overlay
- `Ctrl+Q` — quit the client

The full command reference lives on the
[slash commands](@/docs/slash-commands.md) page.
