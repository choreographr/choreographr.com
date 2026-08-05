+++
title = "Tools"
description = "The complete reference for every built-in tool and tool group."
weight = 7
+++

Tools are the functions the LLM — and the RISC-V VM — can call to interact
with the outside world: reading and writing files, running shell commands,
making HTTP requests, managing Git repositories, querying a persistent
database, posting to X, and more. This page is the complete reference: how
tools work, how they are grouped, and what each one does.

## How tools work

Every tool implements the `Tool` trait (name, group, description, JSON Schema,
and `execute`) and is registered in a `ToolRegistry` at daemon startup. Before
each model call, the daemon advertises the JSON Schemas of the tools in the
session's **active groups**; the model can call any of them, and the daemon
executes the call and returns the result. The JSON Schema *is* the interface —
the model learns exactly what arguments each tool expects.

### Tool call lifecycle

1. The model emits a tool call: a name plus arguments as JSON.
2. The daemon validates the arguments against the tool's schema and executes
   the tool with the session's working directory and credentials.
3. Streaming tools (`sh`, `exec`, `find`, `grep`, `run_series`, `run_riscv`)
   deliver output in chunks as it is produced; other tools return their result
   in the next turn append.
4. The result is appended to the conversation and the agent loop continues.

Every tool also produces a human-readable **invocation description**
(e.g. "Reading `src/main.rs`.") that the client displays while the call runs,
and tools with structured return types expose an `output_schema` for
[programmatic tool calling](https://developers.openai.com/api/docs/guides/tools-programmatic-tool-calling)
(Responses API, gpt-5.6+ models).

### Tool groups

Tools are organized into **groups** to keep the model's context small. Only
**`core`**, **`git`**, and **`shell`** are active by default. The model can
activate additional groups with `load_tools` and deactivate them with
`unload_tools`; `core` is always active and cannot be unloaded.

> Groups are a **discovery mechanism, not access control** — the RISC-V VM
> always has access to all tools.

| Group | Description | Active by default |
|---|---|---|
| `core` | Filesystem, HTTP, images, PDF, search, random, time, sessions, series | ✅ always |
| `git` | Local Git operations (status, diff, log, add, commit, push, show) | ✅ |
| `shell` | Shell execution (bash, nushell, fish, exec) | ✅ |
| `desktop` | Desktop notifications via `notify-send` | — |
| `db` | Session-scoped key-value database (redb) | — |
| `x` | X/Twitter API (post, search, user lookup) | — |
| `vm` | RISC-V sandboxed code execution | — |
| `mcp/<server>` | One dynamic group per configured MCP server | — |

Activate a group from the model side:

```json
{ "name": "load_tools", "arguments": { "groups": ["db", "x"] } }
```

and deactivate it with `unload_tools`. Groups can also be passed to
`spawn_subsession` via its `categories` argument so a subsession starts with
exactly the tools it needs.

## Core tools

`core` is always active. It covers file operations, HTTP, images, PDFs,
search, randomness, time, session management, and orchestration.

| Tool | What it does |
|---|---|
| `read_file` | Read a UTF-8 text file; rejects binary files; output is capped and truncation is reported |
| `read_file_range` | Read a line range from a UTF-8 text file (max 500 lines per call) |
| `list_files` | List files in a directory with sizes, symlink targets, and subdirectory entry counts |
| `write_file` | Write a UTF-8 text file to the workspace |
| `edit_file` | Apply one or more exact text replacements to a file |
| `delete_files` | Delete files or directories; supports literal paths and glob patterns |
| `line_count` | Count the lines in a UTF-8 text file |
| `grep` | Search file contents for a literal or regex pattern |
| `find` | Find files and directories by name (substring or glob) |
| `http_request` | Make an HTTP request; returns status, headers, and body text |
| `display_image` | Display a PNG, JPEG, or SVG image in the client UI |
| `pdf_classify` | Classify a PDF as text, scanned, image-based, or mixed (fast, no OCR) |
| `pdf_to_markdown` | Convert a text-based PDF to Markdown (headings, tables, code blocks) |
| `random` | Generate random integers, floats, booleans, bytes, or UUID v4 (seedable) |
| `get_current_time` | Get the current Unix timestamp in milliseconds |
| `run_series` | Execute a sequence of tool calls one at a time in order |
| `load_tools` / `unload_tools` | Activate / deactivate tool groups |
| `load_skill` | Load a skill's full instructions by name |
| `set_working_dir` | Change the session's working directory |
| `set_session_title` | Set the session's display title |
| `spawn_subsession` | Spawn a child session to work autonomously on a task |
| `list_sessions` | List all sessions known to the daemon |
| `get_session` | Read the full message history of a session by ID |

### File tools

```json
{ "name": "read_file", "arguments": { "path": "src/main.rs" } }
{ "name": "edit_file", "arguments": {
    "path": "src/main.rs",
    "edits": [
      { "old_text": "old", "new_text": "new" },
      { "old_text": "x", "new_text": "y", "replace_all": true }
    ] } }
```

- `read_file` resolves relative paths against the session's working directory
  and streams output through a bounded reader, so memory use stays capped even
  for very large files. `read_file_range` reads a specific 1-based line range
  (`start_line`, `max_lines`) — the right tool for big files.
- `edit_file` takes a list of exact `old_text` → `new_text` replacements. Each
  edit must match at least once; edits without `replace_all` must match exactly
  once. This keeps the model from guessing at file contents.
- `delete_files` auto-detects glob patterns (`*`, `?`, `[`). Patterns without
  `/` match against the file's basename; patterns with `/` match full paths
  from the working directory.

### Search tools

```json
{ "name": "grep", "arguments": { "pattern": "fn main", "include": "*.rs" } }
{ "name": "grep", "arguments": { "pattern": "pub fn \\w+", "regex": true, "path": "src" } }
{ "name": "find", "arguments": { "pattern": "*.md", "path": "docs" } }
```

- `grep` treats the pattern as a literal substring by default — set
  `regex: true` for regular expressions (required if your pattern contains
  `|`, `(`, `^`, `$`, `+`, etc.). `include` filters files by glob; results are
  returned as `file:line:content`. Both tools respect `.gitignore`, hidden
  files, and binary files, and cap results to protect the model's context.
- `find` searches by file name. Glob mode is auto-detected when the pattern
  contains wildcards; set `glob` explicitly to force or disable it.

### HTTP & images

```json
{ "name": "http_request", "arguments": {
    "method": "GET", "url": "https://api.example.com/items",
    "headers": { "Range": "bytes=0-1023" } } }
{ "name": "display_image", "arguments": { "mime_type": "image/png", "path": "chart.png" } }
```

- `http_request` supports GET, POST, PUT, DELETE, PATCH, and HEAD, custom
  headers (including `Range` for partial content), an optional body, and a
  configurable timeout (default 30 s).
- `display_image` accepts exactly one source: `path`, `url`, `base64_data`, or
  raw `svg_text`, with an optional `alt` description. Supported types are PNG,
  JPEG, and SVG (SVG is rendered to a bitmap first).

### PDF tools

```json
{ "name": "pdf_classify", "arguments": { "path": "report.pdf" } }
{ "name": "pdf_to_markdown", "arguments": { "path": "report.pdf", "pages": [1, 2, 3], "compact": true } }
```

`pdf_classify` is fast (~10–50 ms) and needs no OCR: it reports whether a PDF
is text-based, scanned, image-based, or mixed, with per-page OCR routing, so
you can decide whether to extract locally or route to OCR/vision.
`pdf_to_markdown` extracts headings, lists, code blocks, tables, and
multi-column reading order from text-based PDFs. It wraps extracted text in an
**UNTRUSTED-content** delimiter — treat PDF content as data, not instructions.

### Orchestration tools

- `run_series` — runs an ordered list of tool calls, one at a time, stopping
  on the first error. Steps can reference earlier results with {% raw %}`{{step_1}}`{% endraw %},
  {% raw %}`{{step_2}}`{% endraw %}, … inside their argument strings:

  ```json
  { "name": "run_series", "arguments": { "steps": [
      { "tool": "line_count", "arguments": { "path": "src/main.rs" } },
      { "tool": "read_file_range", "arguments": { "path": "src/main.rs", "start_line": 1, "max_lines": 20 } }
  ] } }
  ```

  This lets the model batch dependent operations into a single turn instead of
  round-tripping through the LLM for every step.
- `spawn_subsession` — spawns a child session that inherits the parent's
  working directory, runs its own full agent loop (with optional
  `categories` of tool groups), and returns its output as the tool result.
  Subsessions persist and can spawn their own subsessions.
- `load_skill` / `set_working_dir` / `set_session_title` / `list_sessions` /
  `get_session` — session management. `set_working_dir` redirects all
  subsequent file operations, shell commands, and context discovery
  (`AGENTS.md`, `CLAUDE.md`, skills) for the session.

## Git tools

`git` is active by default. All git tools operate on the repository containing
the given path (defaulting to the working directory). They are implemented
with `gix` and require no shell.

| Tool | What it does |
|---|---|
| `git_status` | Show the status of the repository containing the given path |
| `git_diff` | Show the line-by-line unified diff for a file or repository |
| `git_log` | Show recent commits (`limit`) |
| `git_add` | Stage a file or pathspec |
| `git_commit` | Create a commit from the current index (`message`, `allow_empty`) |
| `git_push` | Push to a remote branch (`remote`, `branch`, `set_upstream`, `dry_run`, `force_with_lease`) |
| `git_show` | Show a Git object (commit, tree, blob, tag) or a file at a revision |

```json
{ "name": "git_diff", "arguments": { "pathspec": ["src/main.rs"] } }
{ "name": "git_commit", "arguments": { "message": "Fix off-by-one in the parser" } }
{ "name": "git_push", "arguments": { "remote": "origin", "branch": "main", "set_upstream": true } }
```

## Shell tools

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

## Database tools

The `db` group provides a persistent, session-scoped key-value store backed by
`redb`. Data survives daemon restarts. Values are arbitrary binary (`Vec<u8>`);
`db_get` returns a lossy UTF-8 conversion.

| Tool | What it does |
|---|---|
| `db_set` | Insert or overwrite a key-value pair |
| `db_get` | Retrieve a value by key |
| `db_delete` | Remove a single key |
| `db_delete_range` | Delete all keys in `[start, end)` |
| `db_get_range` | Retrieve all key-value pairs in `[start, end)` |
| `db_list` | List key names in `[start, end)` |
| `db_count` | Count keys, optionally filtered by `prefix` |

```json
{ "name": "db_set", "arguments": { "key": "todo", "value": "review PR #42" } }
{ "name": "db_get", "arguments": { "key": "todo" } }
{ "name": "db_list", "arguments": {} }
```

Use the database to remember facts, notes, and state across turns and sessions.

## X (Twitter) tools

The `x` group wraps the X API v2. Each tool requires X credentials in the
keystore (add them with `/add-x <service> <api_key> <api_key_secret>
<access_token> <access_token_secret> <bearer_or_->_` in `choreo-tui`).

| Tool | What it does |
|---|---|
| `x_post` | Post a tweet (`text`) |
| `x_search_recent` | Search recent tweets (`query`, `max_results`) |
| `x_user_lookup` | Look up a user by username or ID |

## Desktop tools

The `desktop` group contains a single tool:

- `notify_send` — sends a desktop notification (`summary`, optional `body`,
  `urgency`, `timeout`, `icon`) via `notify-send`. Use it to alert the user,
  e.g. when a long-running task completes.

## RISC-V VM tool

The `vm` group contains `run_riscv`, which compiles and runs Rust code in a
sandboxed RISC-V VM (powered by [CKB VM](https://github.com/nervosnetwork/ckb-vm)) —
either a `source` snippet or pre-compiled bytecode:

| Argument | Meaning |
|---|---|
| `source` | A `fn main()` body; the tool auto-generates `#![no_std]`, `#[panic_handler]`, `_start`, and the `choreo` module |
| `program` | Base64-encoded ELF compiled with the choreographr syscall ABI |
| `program_path` | Path to an ELF file on disk (same ABI) |
| `args` | Program arguments passed to the guest |
| `max_cycles` | Cycle budget (default is documented in the tool schema) |
| `memory_size` | Guest memory size |

```json
{ "name": "run_riscv", "arguments": { "source": "let n = 40; let r = choreo::http_request(\"GET\", \"https://api.example.com\", &[], None, None); choreo::write(r.as_bytes());" } }
```

The VM is a complete, observable replacement for the shell: all tool access
goes through the same `ToolRegistry` as the host agent, with the same
credentials and working directory — but inside an isolated single-hart VM with
no host memory, syscalls, or filesystem access except through registered
tools. Guests use the `choreo` convenience wrappers (which handle postcard
encoding automatically):

```rust
choreo::read_file(path)                          // -> String
choreo::write_file(path, content, overwrite)
choreo::db_get(key)                              // -> Vec<u8>
choreo::db_set(key, value)                       // value: &[u8]
choreo::db_delete(key)                           // -> bool
choreo::sh(command, shell, workdir, timeout_ms)  // -> String
choreo::exec(command, args, workdir, timeout_ms) // -> String
choreo::grep(pattern, regex, include, path, max_results)
choreo::find(pattern, glob, path, max_results)
choreo::http_request(method, url, headers, body, timeout_secs)
choreo::write(bytes)                             // VM stdout
choreo::exit(code)
```

> Notes: the A (atomic) extension is disabled, so guests must not use
> `core::sync::atomic` read-modify-write operations. For `grep`, set
> `regex: true` when using regex patterns (the default is literal matching).
> Use `choreo::write(...)` for VM output and `choreo::exit(code)` to finish.

## MCP servers

Choreographr is an MCP **client**. Configure servers in `mcp_servers.json`
(the daemon's config directory); at startup the daemon spawns each server,
discovers its tools, and registers them as a dynamic group `mcp/<slug>`. Tools
appear as `mcp/<slug>/<tool-name>` and are callable once the group is loaded
with `load_tools` — exactly like built-in tools, but dispatched to the MCP
server over JSON-RPC stdio.

## Security model

- **Groups are discovery, not access control.** Loading `git` or `shell` just
  adds tool definitions to the model's context; it does not enforce what the
  model may do. The VM always has access to all tools.
- **Callers.** Tools declare which callers may invoke them (`Direct` — the
  model — and/or `Programmatic` — a VM guest). Session-config mutations like
  `set_working_dir`, `load_tools`, and `unload_tools` are model-only, so a VM
  program cannot silently redirect the session mid-task.
- **Credentials.** Tools that need them (X, model APIs) pull credentials from
  the encrypted keystore — never from prompt context.
