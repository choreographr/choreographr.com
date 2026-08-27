+++
title = "Core tools"
description = "Files, search, HTTP & images, vision input, web-page rendering, PDF, and orchestration."
weight = 1
+++

`core` is always active. It covers file operations, HTTP, images, vision
input, web-page rendering, PDFs, search, randomness, time, session management,
and orchestration.

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
| `retrieve_webpage` | Render a URL in a local headless browser and return HTML, text, a screenshot, or a PDF |
| `display_image` | Display a PNG, JPEG, SVG, or HEIC image in the client UI |
| `read_image` | Read an image file and feed it to a vision-capable model as image input |
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

## File tools

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

## Search tools

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

  Both tools run on the [`zlob`](https://crates.io/crates/zlob) globbing and
  file-walking engine — SIMD-accelerated, with `.gitignore` support — which is
  also why building Choreographr requires a Zig toolchain: zlob is written in
  Zig and is compiled at build time (see [Installation](@/agent/docs/installation.md)).

## HTTP & images

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
  JPEG, SVG (rasterized at display resolution with system fonts, so vector
  diagrams stay crisp at any terminal size), and HEIC/HEIF. AVIF is supported
  but gated behind the `avif` cargo feature.
- In the terminal client the image appears **inline in the chat history** at
  half the viewport height. Click it for a fullscreen view (`Esc` dismisses).
  Encoding runs on a background thread and picks the best terminal protocol
  automatically — kitty graphics or sixel where supported, with a universal
  fallback everywhere else — so images render in virtually any terminal. See
  [Terminal client](@/agent/docs/terminal.md).

### Vision input (`read_image`)

`read_image` reads an image file from the workspace and feeds it to a
**vision-capable model** as image input on the next request — it is the input
counterpart to `display_image` (which renders an image *out* to you):

```json
{ "name": "read_image", "arguments": { "path": "diagram.png" } }
```

It normalizes the image (resize / MIME / re-encode), reports a text handle
(path, dimensions, MIME type, byte size) the model can reason about, and hands
the normalized bytes to the request builder so the vision model sees the image.
Accepted formats mirror the display surface — PNG, JPEG, WebP, SVG
(rasterized to PNG), HEIC, and more — with EXIF orientation baked in. The
image is carried as a reference (path + metadata) rather than bytes in the
conversation, and the normalized bytes are persisted durably in the
`session_attachments` table so they survive restarts.

```json
{ "name": "read_image", "arguments": { "path": "report-figures/fig-1.jpg" } }
```

### Web page rendering (`retrieve_webpage`)

`retrieve_webpage` renders a URL in a **local headless Chromium/Chrome** and
returns page content (HTML), plain text, a screenshot (PNG), or a PDF. It runs
locally and offline — instead of fetching raw markup, it renders a real
browser, so JavaScript-heavy and bot-protected sites work:

```json
{ "name": "retrieve_webpage", "arguments": { "url": "https://example.com", "action": "text" } }
{ "name": "retrieve_webpage", "arguments": {
    "url": "https://example.com", "action": "screenshot",
    "output_path": "shots/page.png", "full_page": true } }
```

The `action` is `content` (default), `text`, `screenshot`, or `pdf` (which
requires `output_path`). Optional arguments include `selector`, `wait_ms`,
`timeout_ms`, `width`/`height`, and `full_page`. Screenshots are returned
inline (and optionally saved to `output_path`).

- A chromium/Chrome binary must already be installed on the host — the tool
  does **not** auto-download a browser. It prefers `chromium`, falling back to
  the various Chrome bundles (see the binary resolution in the source), and
  honors `CHROMIUM_BIN` / `CHROME_BIN` to point at a specific path.
- It accepts `http`, `https`, and `file` schemes. `file://` URLs let the
  browser read arbitrary local files from the daemon's host — that reach is
  intentional (the browser process runs under the same OS-level sandbox as the
  daemon).
- Each call spins up and tears down a fresh one-shot browser instance — there
  is no persistent session between calls. Navigation timeout is clamped to
  avoid a hostile argument pinning a worker thread.

## PDF tools

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

## Orchestration tools

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
