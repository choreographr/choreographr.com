+++
title = "Choreographr v0.2 (Lindy) Released"
description = "Choreographr v0.2 (Lindy) — now at v0.2.4 — adds OAuth sign-in for model providers and MCP servers, MCP client support, prompt-cache affinity and warming, image generation and editing, first-run onboarding, cross-session reading and image crops, XDG paths, and an owner-only local trust model, on top of arm64 Linux, a command palette and readline keybindings, unified file tools, session pin/archive, on-demand image loading, and a hardened keystore."
date = 2026-09-24
# Draft until the post is finished — remove this line to publish.
draft = true
template = "blog-page.html"
# Top-level `authors` feeds the Atom feed; the `[taxonomies] authors` below
# drives the author pages/byline. Kept in sync.
authors = ["Jonathan Brown"]
[taxonomies]
tags = ["announcement", "rust"]
authors = ["Jonathan Brown"]
+++

Choreographr v0.2 (Lindy) is out now. v0.1 was a working agent on one machine. v0.2 is
where it becomes something you can point at real work: it **signs in with OAuth**
instead of asking for an API key, **plugs in MCP servers**, **edits images** as well
as generating them, **reads across sessions**, and from the first keystroke **walks
you through setup**. It also closes the local-trust gaps a single-user tool could
previously get away with.

Here are the major new features:


## First-run onboarding

An empty session is no longer a blank prompt. It shows a **welcome checklist**
that ticks itself off as you go, naming the keys for each step:

1. **Add an account** — `Alt+A`, then `n`. The provider list puts the common ones
   first and filters as you type, and the account name is **pre-filled** from the
   provider slug, so the usual case is one `Enter`. Paste the key, or create the
   account and run `/login <account>` for a provider that signs in with OAuth.
2. **Use it in this session** — automatic for a session that has no account yet:
   once the daemon confirms the credential, the TUI selects the account for you.
   A session that *already* has an account keeps it, so adding a second key never
   silently switches what an in-use session talks to.
3. **Choose a model** — the picker opens on its own after step 2, and fills in as
   the daemon fetches the new account's model list.

Each step waits for the daemon's confirmation rather than firing optimistically —
selecting an account whose key the daemon rejected would only produce a second
error. If the TUI cannot reach or start the daemon it now **exits immediately and
prints the reason**, instead of retrying into a blank screen.

## Android Termux support

By popular demand Choreographr is now available for Android Termux. The server and TUI client are available for 3 platforms:

* MacOS on Apple Silicon and Intel
* Linux on x86_64 and arm64
* Termux on Android 10+

Follow the [install instructions](@/agent/docs/installation.md).

Here is `choreo-tui` running in Termux, working with an agent on a real codebase
— fetching a profile picture from IPFS, analyzing a photo, coordinating via
blockchain profile tools, reviewing code changes, auditing a workspace, and
debugging a daemon startup problem:

{% set imgs = [
  ['termux-profile-picture.webp', 'choreo-tui on Termux: the agent displays a profile picture fetched from IPFS inline'],
  ['termux-photo-analysis.webp', 'choreo-tui on Termux: analysis of the photo after read_image'],
  ['termux-coord-profile.webp', 'choreo-tui on Termux: fetching an account profile with the coord tools'],
  ['termux-code-diff.webp', 'choreo-tui on Termux: reviewing code changes side-by-side'],
  ['termux-workspace-audit.webp', 'choreo-tui on Termux: a workspace-wide audit, reported in markdown'],
  ['termux-debugging.webp', 'choreo-tui on Termux: debugging a wedged daemon shutdown'],
] %}{% set base = '/blog/2026-09-08-choreographr-0-2-0/' %}
<div class="grid grid-cols-1 sm:grid-cols-3 gap-2 my-6">
{%- for img in imgs -%}
  <figure class="m-0"><img src="{{ get_url(path=base ~ img[0], cachebust=true) | safe }}" alt="{{ img[1] }}" class="w-full h-auto rounded-lg border border-night-700" loading="lazy"></figure>
{%- endfor -%}
</div>
Windows support is almost ready. The GUI app is also under development. It will be available for MacOS & iOS (with native tools and Apple Intelligence support), Linux, Android and Windows (with Copilot+ support).

## Improved Image Support

The images below show a `choreo-tui` session in which the image at
`/home/jbrown/Images/ship.jpeg` is displayed inline with the `display_image` tool,
then read with the new `read_image` tool so the model can analyze it:

![choreo-tui: displaying an image inline with the display_image tool](/blog/2026-09-08-choreographr-0-2-0/tui-display-image.webp)

![choreo-tui: the model analyzing the image after read_image](/blog/2026-09-08-choreographr-0-2-0/tui-read-image-analysis.webp)

* New `read_image` tool for llm image vision.
* images handled by `read_image` and `display_image` are now persisted in `session_attachments` db table.
* supported image formats: JPEG, PNG, GIF, WebP, BMP, TIFF, TGA, DDS, ICO, PNM, HDR/Radiance, OpenEXR, Farbfeld, QOI, SVG, HEIC/HEIF. AVIF and JPEG-XL coming soon. Images are now automatically rotated based on EXIF data.

### Image generation

The new `generate_image` tool lets the model produce an image from a text prompt
using the session's image-capable provider. The generated bytes re-enter the same
inline display pipeline as `display_image`, so the image is shown in the TUI,
persisted, and fed back to the model through vision — the model sees its own
generation and can refine it.

The screenshot below shows a `choreo-tui` session in which the model generates an
image with the `generate_image` tool and displays it inline:

![choreo-tui: an image generated by the model with the generate_image tool, rendered inline](/blog/2026-09-08-choreographr-0-2-0/tui-generate-image.webp)

* New `generate_image` tool in a new `image` tool group (enable with `load_tools image`).
* Provider-agnostic: OpenAI-compatible endpoints (`gpt-image-1`) and z.ai / Zhipu GLM (`glm-image`), with more providers to follow.
* Model selection is catalog-driven — an explicit `model` argument always wins; otherwise the provider's verified image models are picked by priority. There is no guessed fallback model.
* Knobs: `size` (`1024x1024`, `1024x1536`, `1536x1024`), `quality`, `output_format` (PNG/JPEG/WebP), `background` (opaque/transparent) and `alt` text.
* The credential never reaches the tool: provider resolution runs through the daemon command loop, scoped to the requesting session so a cancel closes an in-flight generation too.

### Image editing

`edit_image` is the other half of the `image` group: it modifies one or more
existing images from a text prompt (image-to-image). Each input is either a local
file path or a **session reference** to an image already in the conversation —
`@last` for the most recent one, or `@display:<turn>:<index>` /
`@result:<turn>:<call_id>` for an explicit one — so "make that darker" works on the
image the model just produced or the one you just shared, with no path juggling.

* Four adapters: OpenAI Images, **xAI** `grok-imagine` (OpenAI-protocol generation,
  a JSON body on `/images/edits` for editing), **Google Gemini** image models
  (generate and edit through `generateContent`, inputs sent as `inlineData`), and
  **fal.ai**. z.ai / Zhipu is generation-only, and Anthropic has no image backend.
* `mask` support (a PNG path whose **transparent** region is the area regenerated,
  the opaque region preserved) on the models that can inpaint.
* Model selection is catalog-driven, like generation: an explicit `model` wins,
  otherwise the provider's *edit-capable* models are picked by priority. Edit
  capability is overlay-only policy, and `edit_image` **fails closed** when the
  resolved provider pins no edit-capable model.
* Output re-enters the same pipeline as `display_image` — displayed inline,
  persisted, and fed back through vision — so the model can inspect its own edit
  and take another pass.

## `retrieve_webpage` Tool

In addition to the low-level `http_request` there is a new tool `retrieve_webpage` that uses the [headless_chrome](https://crates.io/crates/headless_chrome) Rust crate to load a webpage via a local headless Chromium/Chrome. It provides the webpage to the llm as text, screenshot or pdf.

This has many addtional use-cases:

* Reading JavaScript-rendered pages
* Getting past bot protection / challenge pages, e.g. Cloudflare
* When used in conjunction with the `read_image` tool, it enables the the LLM to "see" the page, not just the text content. This can be used for iterative web design by the LLM.
* PDF generation from web pages - great for archiving.
* Rendering local files (file://) - this can be a great way for the LLM to generate PDFs - write them as HTML/CSS and then render to PDF.
* Surgical extraction with selector - specific components of the DOM can be extracted in isolation.
* Element-scoped screenshots now render elements below the fold instead of a blank background.

The screenshots below show a `choreo-tui` session in which `retrieve_webpage` is used
to take a screenshot of a page — which is displayed inline in the TUI — and then read
with `read_image` so the model can see it:

![choreo-tui: the retrieve_webpage tool capturing a screenshot of the choreographr.com homepage, rendered inline](/blog/2026-09-08-choreographr-0-2-0/tui-retrieve-webpage-screenshot.webp)

## Preliminary EVM / Polkadot tools enabled

Giving an AI agent blockchain access is a core component of Choreographr. It now has read-only access.

* EVM ([alloy](https://crates.io/crates/alloy)) & Substrate/Polkadot ([subxt](https://crates.io/crates/subxt)) query tools
* Only tokio-dependent crate: daemon stays thread-only, calls sync execute_* that block_on a sidecar runtime
* EVM: balance, ERC-20 balance, block, contract call, transaction, logs, nonce, gas, chain info, ENS resolution (real Universal-Resolver calls, replacing fabricated RPC methods)
* Substrate: chain info, balance, decoded storage query, block

The "content" tools to access the Choreographr blockchain (previously Acuity) are under development and currently disabled. They will be enabled in a future release.

## TUI improvements

* Modal account wizard with searchable provider picker

![choreo-tui: the modal account wizard with the searchable provider picker](/blog/2026-09-08-choreographr-0-2-0/tui-provider-picker.webp)
* Mouse support — select-to-copy , picker click-to-select + mouse wheel, click account/session rows to select and enter
* Per-session unsent input drafts, Ctrl+Backspace clears the draft prompt
* Command shortcuts moved to `Alt+`, freeing `Ctrl+` for readline editing keys
* Request failures reported in the UI with a wrapped transcript error block
* Tool output margins removed
* Account slug shown in the status bar (instead of the provider slug)
* Prompts submitted while the attached session is busy are rejected with "Session is not idle, please wait before prompting." — the text stays in the input bar, and `/continue` and Alt+Enter are covered by the same guard
* LaTeX math rendered as pretty Unicode

![choreo-tui: LaTeX math rendered as pretty Unicode in the TUI](/blog/2026-09-08-choreographr-0-2-0/tui-latex-unicode.webp)

* **The status bar names the phase you are in** — `sending` → `waiting` →
  `reasoning` → `responding` — so a multi-second wait for the model's first
  token no longer looks like a stalled upload.
* **The model picker opens instantly.** It paints from the daemon's cache (or
  the local catalog's curated ids) and refreshes in place when the live list
  lands, keeping the row you are on and labelling itself `provisional` until the
  real list arrives.
* **The terminal knows what is going on.** The client sets the window/tab title
  (OSC 2) to `choreo-tui — <session title>`, and reports each session's state
  through the terminal's **Program Status Protocol** (OSC 7501), so a tab shows
  working/idle and a background agent that just finished keeps its `done` or
  `error` record after its status drops back to idle.
* **A streaming response stays pinned** to the top of the viewport while it
  grows, instead of scrolling its first line out of view.
* Ordered lists keep the **source numbers** from the document and right-align
  them, rather than renumbering from one.
* **Every displayed string is normalized at the widget sink** — control
  characters, escape sequences, and bidirectional-formatting overrides are
  stripped from model output, tool names, identifiers, and pasted text, and tabs
  are expanded before markdown rendering so a code box's frame stays aligned.

## Daemon autostart

`choreo-tui` can now start the daemon for you. If it cannot reach one, it spawns
a sibling `choreographr` process as a detached child — no separate "start the
server" step — and shows a status line while it waits for the socket. The
connection is attempted directly first, so autostart only kicks in when the dial
fails and never races or steals a live daemon's socket.

* Autostarted daemons run with `--auto-exit` (shut down gracefully when the last
  client disconnects) and `--log-file` (diagnostics to a per-process log under
  the platform temp dir).
* Manual start still works exactly as before — what you want for a long-lived or
  remote daemon. TCP mode (`--tcp-addr`) never autostarts.
* The daemon refuses to replace a socket a live daemon is still listening on,
  and names the socket path in bind errors.

## Cancellation & resilience

* Per-session socket registries — cancelling a request now force-closes exactly
  that session's provider sockets, unblocking a wedged reader without disturbing
  other concurrent sessions (or their children).
* Survives suspend/resume: the daemon listens for platform power events
  (`choreo-power-events`) and force-closes sockets when the machine sleeps,
  pruning dead connections on wake.
* The new `choreo-sockreg` crate tracks live sockets (with TCP keepalive tuning)
  so the single thread that decides a cancel can close exactly the right
  connections.
* **Each turn is persisted at the agent loop's iteration boundary**, so a crash
  (or a killed daemon) loses at most the iteration that was in flight rather
  than every tool call since the last checkpoint — and a checkpointed turn is
  written once, not rewritten per event.

## Inference & provider improvements

* Chat-completions `finish_reason` is now parsed: an output-limited response is
  flagged with a visible "⚠ response truncated (length limit)" line, and
  content-filter refusals and context-window overflow surface as clear,
  non-retryable errors instead of empty or blank replies.
* Cached prompt tokens (`prompt_tokens_details.cached_tokens`) are parsed and
  shown in the TUI session detail as `(N cached)`.
* GLM models: `reasoning_effort` slugs are mapped to z.ai's documented values,
  and the `zai`/`zhipuai` slugs pin `max_tokens` (z.ai's API does not accept
  `max_completion_tokens`); the `zai` provider is repinned to z.ai's standard
  PaaS gateway.
* Coordinated providers — the context window, reasoning capability, and
  provider routing stay consistent while the keystore is locked, and switching
  a session's account always dials the new provider.
* **Structured reasoning is replayed verbatim.** Chat-completions routes that
  carry reasoning as a `reasoning_details` array (the OpenRouter resellers,
  Ollama Cloud, and other gateways — 14 catalog models) now capture it,
  normalize it (adjacent text/summary entries merge, encrypted entries stay
  discrete, unrecognised types drop, the payload is capped per turn), and send it
  back exactly as produced, so multi-turn tool loops no longer lose the
  signature a provider expects.
* **Request bodies are compressed** on providers that can decompress them: a
  `request_compression = "gzip"` (or `"zstd"`) provider scalar in the catalog
  overlay, opt-in because the server has to decode it. Compression runs once per
  request and is reused across retries, and a provider that answers `415` is
  downgraded to identity in place and remembered for the rest of the process.
* Model listing was restored for the opencode gateways, and transient
  gateway `400`s that are really message-content complaints are retried
  instead of failing the turn.

## Simplified keystore semantics

* Per-daemon keystore unlock keys with hardened per-daemon keystore state
* Unlock UX rework — /unlock uses the stored key; /unlock <key> records it; identity.pk.enc removed entirely
* BindKeystore as the sole binding path — Unlock/AddCredential are verify-only, fresh keys only for bind; frontend auto-bind: clients bind fresh unbound daemons and confirm on Bound; documented binding model + ordering invariant; shared auto-bind state machine
* Client access-control & trust model — Noise XX first-contact mode with a TCP wire handshake preamble, fingerprint rendering + known_servers.toml pin store, pinned-mode trust flow with fingerprint confirmation, hot-reloaded client ACL from authorized_clients.toml, /acl add enrollment from a local connection, choreographr acl-add and fingerprint subcommands, tightened fingerprint compare + pinned-mode failure UX; trust model documented in ARCHITECTURE.md
* Credential adds now carry a **typed** credential (API key, X tokens, OAuth
  grant) rather than a client-encrypted blob, so no key material rides the add
  path; the daemon encrypts each credential to its own binding key before
  storing it, and a locked daemon refuses the add instead of implicitly
  unlocking.
* TUI refuses to start unauthorized daemons and never crashes on connection errors

## Sign in with OAuth

API keys are no longer the only way in. Choreographr is now an **OAuth client**,
for model providers and for MCP servers — one code path, one credential store.

**Providers.** A provider whose catalog entry carries an OAuth profile (such as
`chatgpt`, for a ChatGPT/Codex subscription) signs in with
`/login <account>` — alias `/add-oauth` — which opens the provider's consent
screen through a loopback callback. Pass `--device` for the headless
device-code flow on a remote or SSH host. The durable grant (refresh token,
client registration, identity claim) is encrypted at rest in the keystore; the
short-lived access token lives in daemon memory only and is refreshed and
rotated transparently — proactively before it expires, and force-once on a
`401` — with a terminal rejection surfacing a re-login notice instead of a dead
session. An account holds **one** credential, so signing in replaces an existing
key (and vice versa).

**MCP servers.** A remote server that needs an interactive sign-in declares an
`oauth` block in `mcp.json` (all fields optional: `clientId`, `callbackPort`,
`scopes`, `authorizationServer`, and `clientSecretEnv` — the *name* of an
environment variable holding a confidential client's secret, never the secret
itself), and `/mcp login <slug>` runs the PKCE sign-in:

* **Discovery** starts from the authorization challenge: an unauthenticated
  request's `WWW-Authenticate` header names the protected-resource metadata URL;
  failing that, RFC 9728 metadata → RFC 8414 or OpenID Connect Discovery, or the
  explicit `authorizationServer`. A client is registered dynamically when no
  `clientId` is configured. There is a paste-URL fallback for headless hosts
  (MCP's flow has no device-code mode).
* **Confidential clients** are supported, with the secret sent to the token
  endpoint as HTTP Basic — or `client_secret_post` when the server advertises
  only that — and stored in the grant so a connect-time refresh can
  re-authenticate. The authorization response's `iss` is validated against the
  discovered issuer when the server advertises RFC 9207 support.
* **Grants are keyed by target**, not slug (`mcp:<slug>|<target-hash>`), so a
  same-named server on a different endpoint keeps its own credential. A stored
  grant whose issuer or resource no longer matches the configured server is
  treated as absent (fail-closed) and surfaces a re-login, and a project server's
  sign-in is refused while that project root is untrusted.
* **Sign-in finishes the job**: the daemon brings the server up as soon as the
  grant is stored, so no `/mcp reconnect` is needed. A server that issues no
  refresh token (e.g. GitHub's remote MCP behind an OAuth App) still works — its
  long-lived access token is stored, so it survives a restart.

`/mcp logout <slug>` removes the grant, and `/mcp` shows each server's auth state
alongside its transport, tool count, and last error.

## Other

* Brotli response decompression in ureq HTTP
* Tool-output safety: new choreo-sanitize crate fixing six tool-output safety gaps; harmonized sanitization and bounded streaming across all tools
* Shell tools can raise the outer deadline above the 300s floor
* Improved OpenCode gateway compatibility.
* Choreographr user agent string on LLM requests.
* Background model prefetch — model lists warmed on session join instead of at unlock, never blocking ListModels
* glm-5.3-flash added to opencode overlay
* zstd compression of session_turns database table
* Provider & model catalog data is downloaded live from [models.dev](https://models.dev) — a bundled snapshot plus a policy overlay, refreshed at runtime — so new providers and models appear without a code change
* Live config watching — edits to `accounts.toml` hot-reload, and only sessions bound to a changed or removed account rebuild their provider clients; the file watcher also rescans the directory after a kernel event-queue overflow, so changes are never missed

## Linux on arm64

The Linux channel now ships **arm64 (aarch64)** alongside x86-64: a static
`aarch64-unknown-linux-musl` tarball plus arm64 `.deb` and `.rpm` packages, so
a Raspberry Pi, an arm64 server, or an Apple-Silicon VM installs from prebuilt
binaries exactly like x86-64.

## Command palette & keybindings

`choreo-tui` gained an inline **command palette**: type `/` on an empty prompt
and a floating list appears above the input — `Enter` runs the highlighted
command, `Tab` completes the name, `↑`/`↓` move, and `Esc` returns to the
prompt. Commands resolve through one shared catalog, so the palette and the
parser can never disagree.

The chat-page command shortcuts moved from `Ctrl+<letter>` to `Alt+<letter>`
(`Alt+A` accounts, `Alt+S` sessions, `Alt+M` models, `Alt+R` reasoning, `Alt+H`
help, `Alt+Q` quit, `Alt+Up`/`Alt+Down` undo/redo; `Alt+Enter` continue is
unchanged). That frees the whole `Ctrl+<letter>` space for **readline editing
keys** — `Ctrl+A`/`Ctrl+E`, `Ctrl+B`/`Ctrl+F`, `Ctrl+K`, `Ctrl+W`, `Ctrl+T`,
`Ctrl+P`/`Ctrl+N`, `Alt+B`/`Alt+F` and friends — so every text field behaves
like a shell prompt. A new `/new [title]` command creates a session and
switches you straight to it.

## Session management: pin & archive

The session manager now has two views — live and archived — toggled with `Tab`.
Press `p` to pin a session (pinned sessions float to the top of both lists) and
`a` to archive or unarchive it. The daemon owns both flags and broadcasts every
change, so the list never diverges from the server. The TUI also remembers each
session's **scroll position**, so switching away and back reopens where you left
off.

## Unified file tools

The read tools are now one: `read_file` returns a numbered view (a `path:` /
`lines: a-b of N` header plus `N | content` lines) and takes optional
`start_line` and `max_lines`, with an explicit continuation marker whenever the
window or the byte budget clips the output — the separate `read_file_range`
tool is gone. `edit_file` gained `near_line` to disambiguate a repeated
`old_text`, reports candidate lines when a match is ambiguous or missing,
rejects no-op edits, and handles CRLF files correctly.

## Performance: images on demand

Displayed images are no longer shipped inside session snapshots — only their
metadata is. The client fetches the bytes on demand as an image scrolls into
view, so opening a long session no longer transfers its entire image history,
and multi-image turns stream in O(N) instead of O(N²).

## Unified CLI & logging

Every binary (daemon, TUI, GUI, IM, ACP) now shares one logging policy via a
new `choreo-shared` crate: default `info`, `-v` debug, `-vv` trace, `-q` warn.
Explicit flags now **take precedence over `RUST_LOG`** (the Unix convention),
and the TUI's runaway trace-level file log is fixed.

## Better defaults

* `retrieve_webpage` gained an opt-in `webgl` argument — new-headless Chromium
  with software GL, so canvas/3D pages render instead of coming back blank.
* Bulky, machine-oriented tool results (`list_sessions`, the shell/exec family,
  `grep`, `retrieve_webpage`, `spawn_subsession`) now **default to collapsed**
  in the TUI, one click from the full body.
* The default system prompt now tells the agent to **verify factual claims**
  before asserting them — prioritising anything time-sensitive,
  location-specific, contested, or specialised — and to flag uncertainty rather
  than present an unverified claim as settled.
* It also asks for **correctness over convenience**: prefer the correct solution
  even when it is more work, treat simplicity as a goal rather than an excuse to
  cut corners, and don't quietly simplify the problem to make it easy.
* **Emphasis guidance** — bold the few words that carry the point (key names,
  numbers, verdicts, warnings), at most one or two per paragraph, never inside
  code or headings, and reach for a list or table instead when most of a
  paragraph would be bold.
* **Effort estimates in steps, not human-days** — wall-clock time is modelled in
  tool calls, tokens, and build/test latency, with the genuinely slow parts
  (builds, CI, rate limits) called out honestly.
* Models are asked to **tag fenced code blocks with a language** (the renderer
  styles them with it) and to describe the present in code comments rather than
  narrating the change history.
* The `random` tool description was expanded with the cases it is actually for —
  picking among interchangeable options, A/B buckets, fixtures and placeholder
  data, fuzz inputs — instead of leaving the model to invent constants.
* The minimum supported Rust version is now **1.99** (building from source).

## MCP servers

Choreographr is now an **MCP (Model Context Protocol) client**, built on the
official [`rmcp`](https://crates.io/crates/rmcp) SDK. Plug in any MCP server —
local subprocess or remote — and its tools appear to the model like native ones.

* **Two transports** — a stdio subprocess (`command`, plus `args`/`env`/`cwd`)
  or a remote **Streamable HTTP** endpoint (`url`, plus `headers`).
* **Two config tiers** — a daemon-wide `mcp.json` under the config directory,
  visible to every session, plus a project `.mcp.json` found by walking up from
  the session's working directory. A project's servers are **gated behind
  trust**: they are read (so `/mcp status` can report what is ignored) but
  never spawned until you run `/mcp trust`.
* **Live catalogue** — a server that changes its tool or resource list
  (via `subscriptions/listen`) refreshes the daemon's catalogue in place, with
  no restart. Discovered tools are exposed under an `mcp/<slug>` group.
* **Manageable** — `/mcp` shows the live state of every server (tier, transport,
  tool count, last error), and the `choreographr mcp` CLI does
  `list`/`add`/`remove`/`reconnect`/`reload`. Each stdio server's stderr is
  captured to its own owner-only log file.
* **Hardened** — stdio children inherit a stripped environment (no `LD_*`,
  `DYLD_*`, `PYTHONPATH`, `PERL5LIB`, `RUBYLIB`), tool names are sanitized to
  the provider-safe alphabet, and calls are deadline-bounded and
  concurrency-capped per server. MCP support is built into the default release
  binaries; a server's tools live under an `mcp/<slug>` group you activate with
  `load_tools`.
* **Resources, progress, and the MRTR loop** — a server that declares resources
  has them exposed to the model as list/read wrapper tools, its progress
  notifications stream into the TUI as live output, and the model's
  `input_required` retry loop is driven for you instead of stalling a call.
* **Trust is revocable at runtime.** `/mcp untrust` drops that project's live
  connections immediately rather than waiting for a restart, and a project
  server that changes its tool list propagates into every live session's
  overlay. The daemon-tier `mcp.json` and `trust.toml` hot-reload through the
  config watcher, and a `shared = false` daemon server keeps one connection per
  session instead of one for the whole daemon.

```text
# in choreo-tui
/mcp                           # every server, its transport, auth state, and tool count
/mcp login shopify             # PKCE sign-in; the grant lands in the keystore
/mcp logout shopify            # drop the grant

# offline / from a shell
choreographr mcp list          # configured servers
choreographr mcp reload        # reconcile the config on a running daemon
```

## Prompt-cache warming

A warm ping re-sends the last request with a one-token output cap to refresh the
provider's prompt cache before its TTL expires, so the next real turn reads the
prefix from cache instead of re-writing it. It is **off by default** and gated
per account by a billing `meter`: `payg` and `tokens` accounts warm when the
saving clears the threshold, while `requests`, `flat`, and `unknown` never do —
a ping burns quota, so it is not free everywhere. Enable it with
`[cache_warming] mode = "streaming"`, which fires a warmer thread while a tool
call is blocking. Anthropic prompt caching is also enabled, and cache-read and
cache-write tokens are reported in the session detail.

Three things make the warm cache more likely to be *your* cache:

* **Per-session cache affinity.** Each request carries the conversation's real
  session id in the affinity field its provider documents — OpenAI and Venice
  take `prompt_cache_key`, OpenRouter prefers its own `session_id` — so a
  session's turns route to a backend whose prefix cache is warm. It is always the
  real session id, never a constant, which would pin every session to one routing
  bucket. Override per account with `prompt_cache_affinity = true`.
* **Extended retention, per model.** The request field that asks for a longer
  cache differs by model generation (a top-level `prompt_cache_retention = "24h"`
  on pre-GPT-5.6 OpenAI models, a nested `prompt_cache_options.ttl = "12h"` on the
  Responses API for GPT-5.6+), so it is a per-model overlay scalar rather than a
  provider setting — the spelling is never inferred from a model id, and it is
  emitted only when the model also declares a long cache tier. Warming now
  schedules against the **lifetime the request actually asked for** instead of
  always assuming the minutes-long tier. The selector ships dormant — no bundled
  model is seeded with it yet — so it is there for whoever needs it.
* **Rejection memory.** A provider that answers a prompt-cache field with a `400`
  has that field withheld for that provider and model from then on, rather than
  re-sent on every later turn and failing that model until the daemon restarts —
  and the detector looks at **every** cache field the body carried, since an
  account-level affinity override can put two of them on the same request.

Cache hits are now reported for **DeepSeek, the OpenAI Responses API, and
Gemini** as well, alongside the Anthropic and chat-completions paths, and
cache-write tokens are accumulated into the session's billing totals.

## Images: more providers, editing, and crops

`generate_image` gained a **fal.ai** adapter alongside OpenAI Images and
z.ai / Zhipu GLM, plus a `seed` argument for reproducible fal generations.
`edit_image` adds **xAI** and **Google Gemini** editing on top of OpenAI Images
and fal.ai, with session references (`@last`) and a `mask` for inpainting.

`read_image` gained a **`region`** argument (fractions of the image) that crops
server-side before the bytes reach the model — a cheap way to zoom a vision
model into part of a large figure. The normalized image the model saw is now
also what the client renders, so crops and EXIF-rotated frames display exactly
as the model receives them.

Also landed in the provider layer this cycle, though not yet exposed as a tool: a
**fal.ai video-generation client** over its queue API (submit a job, poll it to
completion, fetch the finished artifact) with a job-wide deadline and best-effort
cancel.

## Reading across sessions

The new `read_session` tool reads another session's conversation text — the
user messages, assistant responses, and the assistant's displayed reasoning —
given its ID from `list_sessions`. A result researched in one session can be
reused in another. Tool inputs and results, and the opaque reasoning artifacts
(encrypted provider blobs, thinking blocks), stay daemon-only.

## Terminal rendering

* Fenced code blocks now render as **bordered code panels**, with the language
  tag and syntax highlighting (`base16-eighties.dark`).
* Block quotes get a bar gutter and italic text.
* Pinned sessions show a pushpin.
* Markdown table frames follow nushell's rounded style.

## Paths: XDG and `--base-dir`

The socket, config, data, and logs now resolve through the **XDG** directories
by default (`$XDG_RUNTIME_DIR`, `$XDG_CONFIG_HOME`, `$XDG_DATA_HOME`,
`$XDG_STATE_HOME`). Every binary also accepts `--base-dir <PATH>` (or
`CHOREOGRAPHR_BASE_DIR`) to relocate the whole instance under one root, and
`choreographr migrate --base-dir <PATH>` moves an existing install — copying the
keystore files verbatim so clients keep their pinned server key and do not need
to re-pair.

## Security & robustness

* **The local domain is owner-only.** The Unix socket — which carries no Noise
  handshake, so anything that reaches it is fully trusted — is created `0600`
  inside a directory only its owner can traverse. With no `--base-dir` and no
  `$XDG_RUNTIME_DIR`, that directory is a per-uid
  `temp_dir()/choreographr-<uid>`, so parallel users on a shared `/tmp` neither
  collide nor share a parent. The `redb` store (plaintext transcripts and tool
  output), `known_servers.toml` (the private unlock keys), and the log files are
  owner-only too, and `known_servers.toml` is now opened `O_NOFOLLOW` and
  owner-checked **before** it is parsed — a planted pin would otherwise steer
  the next Noise IK handshake. A directory owned by someone else is refused
  outright rather than warned about.
* **Logs never contain payloads.** Prompts, model output, tool arguments and
  results, and credentials are gone from every log and error path — replaced by
  ids, kinds, lengths, and counts — and log files are pruned by age (one week)
  rather than by count, so a quiet install keeps its history.
* **Model output cannot rewrite your terminal.** Every displayed string is
  filtered at its widget sink, and bidirectional-formatting controls are
  stripped from the free-text fields the client writes back out (the OSC 2
  window title and the OSC 7501 status record), so a hostile session title
  cannot visually reorder or spoof them.
* `git_push` no longer lets model input be parsed as git options — a remote or
  branch beginning with `-` could inject `--upload-pack` and friends; everything
  after a literal `--` is now positional.
* OAuth endpoints pass one shared policy: userinfo endpoints are rejected, the
  authorize URL is vetted, redirects are pinned and bounded, remote MCP
  discovery refuses loopback targets, and secrets stay out of non-zeroizing
  buffers.
* Provider-CDN downloads no longer follow redirects past the SSRF guard.
* The image decode path is bounded by **total pixels**, not just per-side
  dimensions, against decompression bombs.
* An output-token-limited response that cuts a tool call short is now recovered
  (the truncated call is recovered rather than failing the turn), and an idle
  SSE socket read no longer aborts a stream.

## Upgrading

Prebuilt binaries for macOS (Apple Silicon and Intel), Linux (x86-64 and
arm64), and Android Termux — see the
[installation guide](@/agent/docs/installation.md).

Full release notes: [v0.2.0](https://github.com/choreographr/choreographr/releases/tag/v0.2.0),
[v0.2.1](https://github.com/choreographr/choreographr/releases/tag/v0.2.1),
[v0.2.2](https://github.com/choreographr/choreographr/releases/tag/v0.2.2),
[v0.2.3](https://github.com/choreographr/choreographr/releases/tag/v0.2.3), and
[v0.2.4](https://github.com/choreographr/choreographr/releases/tag/v0.2.4) on GitHub.

We'd love your help — star the
[repo](https://github.com/choreographr/choreographr), open
[issues](https://github.com/choreographr/choreographr/issues), and join the
[Telegram community](https://t.me/choreographr).
