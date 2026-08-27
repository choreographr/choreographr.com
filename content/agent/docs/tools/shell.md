+++
title = "Shell tools"
description = "Non-interactive shell execution: exec, sh, nushell, and fish."
weight = 3
+++

`shell` is active by default. All shell tools are **non-interactive** —
commands that read from stdin will hang — and share a common timeout
(default 30 s) and `workdir`.

| Tool | What it does |
|---|---|
| `exec` | Execute a single program directly, no shell parsing (e.g. `cargo build`) |
| `sh` | Execute a command with a POSIX-compatible shell (`bash`, `dash`, or `zsh`), with pipes, redirects, globs, and env vars |
| `nushell` | Execute a nushell command (registered only if `nu` is installed) |
| `fish` | Execute a fish shell command (registered only if `fish` is installed) |

```json
{ "name": "exec", "arguments": { "command": "cargo", "args": ["build"], "timeout": 120000 } }
{ "name": "sh", "arguments": { "command": "cargo test | tail -20", "shell": "bash" } }
```

Rule of thumb: use `exec` when you are certain the program exists and needs no
shell features; use `sh` (or `nushell`/`fish`) for anything that needs pipes,
globs, or environment variables.
