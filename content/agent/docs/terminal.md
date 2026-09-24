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
- **Tool results** — streaming execution descriptions and collapsible
  per-result bodies; bulky, machine-oriented results (`list_sessions`, the
  shell/exec family, `grep`, `retrieve_webpage`, `spawn_subsession`) start
  **collapsed** (one click from the full body), while errors stay expanded.
- **Selection & copy** — drag with the mouse to select text in the history pane
  and copy it via OSC 52 (a cross-terminal clipboard escape). Selection follows
  the cursor while scrolling, stays anchored to the text mid-gesture, and is
  copied as unwrapped text.
- **Per-session drafts & scroll** — an unsent prompt is kept per session, so
  switching sessions and returning preserves what you were typing
  (`Ctrl+Backspace` clears the draft); the history pane also reopens at the
  scroll position you left.

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

## Input & keybindings

Typing `/` on an empty prompt opens the **command palette** — a floating list
of commands above the input. `Enter` runs the highlighted command, `Tab`
completes the name, `↑`/`↓` move the selection, and `Esc` returns to the
prompt. Commands resolve through one shared catalog, so the palette and the
parser never disagree.

Command shortcuts use `Alt+` (the `Ctrl+<letter>` space is reserved for
editing): `Alt+A` accounts, `Alt+S` sessions, `Alt+M` models, `Alt+R`
reasoning, `Alt+H` help, `Alt+Q` quit, `Alt+Up`/`Alt+Down` undo/redo, and
`Alt+Enter` continue.

Every text field honours shell-style **readline editing keys**:
`Ctrl+A`/`Ctrl+E` (start/end of line), `Ctrl+B`/`Ctrl+F` (one char),
`Alt+B`/`Alt+F` (one word), `Ctrl+D`/`Ctrl+H` (delete), `Ctrl+K` (kill to end),
`Ctrl+T` (transpose), `Ctrl+W`/`Alt+D`/`Alt+Backspace` (word kills), and
`Ctrl+P`/`Ctrl+N` (previous/next history).

## Managing sessions

- `Alt+S` — session manager: list, switch, create, and delete sessions
- `Alt+A` — accounts page: add, remove, and select AI provider accounts
- `Alt+M` — model selector
- `Alt+R` — cycle the reasoning effort
- `Alt+H` — toggle the keybinding help overlay
- `Alt+Q` — quit the client

Inside the session manager, `Tab` toggles between the live and archived lists,
`p` pins or unpins a session (pinned sessions sort to the top), and `a`
archives or unarchives one.

The full command reference lives on the
[slash commands](@/agent/docs/slash-commands.md) page.
