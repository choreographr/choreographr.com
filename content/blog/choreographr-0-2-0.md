+++
title = "Choreographr v0.2.0 Released"
description = "Choreographr v0.2.0 is out — STUB: summarize the headline features of this release in one sentence here."
# TODO: set the real release date.
date = 2026-09-06
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

<!-- TODO: opening hook — what changed since v0.1.0 and why it matters. -->

Choreographr v0.2.0 is out now. Here are the major new features:


## Android Termux / Windows support

By popular demand Choreographr is now packaged for 4 platforms:

* MacOS
* Linux
* Android Termux
* Windows

Follow the [Install Instructions](.)


## Improved Image Support

* New `read_image` tool for llm image vision.
* images handled by `read_image` and `show_image` are now persisted in `session_attachments` db table.
* supported image formats: JPEG, PNG, GIF, WebP, BMP, TIFF, TGA, DDS, ICO, PNM, HDR/Radiance, OpenEXR, Farbfeld, QOI, SVG, HEIC/HEIF. AVIF and JPEG-XL coming soon. Images are now automatically rotated based on EXIF data.

## `retrieve_webpage` Tool

In addition to the low-level `http_request` there is a new tool `retrieve_webpage` that uses the [headless_chrome](https://crates.io/crates/headless_chrome) Rust crate to load a webpage via a local headless Chromium/Chrome. It provides the webpage to the llm as text, screenshot or pdf.

This has many addtional use-cases:

* Reading JavaScript-rendered pages
* Getting past bot protection / challenge pages, e.g. Cloudflare
* When used in conjunction with the `read_image` tool, it enables the the LLM to "see" the page, not just the text content. This can be used for iterative web design by the LLM.
* PDF generation from web pages - great for archiving.
* Rendering local files (file://) - this can be a great way for the LLM to generate PDFs - write them as HTML/CSS and then render to PDF.
* Surgical extraction with selector - specific components of the DOM can be extracted in isolation.

## Preliminary EVM / Polkadot tools enabled

Giving an AI agent blockchain access is a core component of Choreographr. It now has read-only access.

• EVM ([alloy](https://crates.io/crates/alloy)) & Substrate/Polkadot ([subxt](https://crates.io/crates/subxt)) query tools
• Only tokio-dependent crate: daemon stays thread-only, calls sync execute_* that block_on a sidecar runtime
• EVM: balance, ERC-20 balance, block, contract call, transaction, logs, nonce, gas, chain info, ENS resolution (real Universal-Resolver calls, replacing fabricated RPC methods)
• Substrate: chain info, balance, decoded storage query, block

The "content" tools to access the Choreographr blockchain (previously Acuity) are under development and currently disabled. They will be enabled in a future release.

## TUI improvements

* Modal account wizard with searchable provider picker
* Mouse support — select-to-copy , picker click-to-select + mouse wheel, click account/session rows to select and enter
* Per-session unsent input drafts, Ctrl+Backspace clears the draft prompt
* Model selector rebound to Ctrl+O for legacy terminals, that don't support Ctrl+M
* Request failures reported in the UI with a wrapped transcript error block (44c0e01, 3f6418e)
* Tool output margins removed
* LaTeX math rendered as pretty Unicode

## Provider model data automatically downloaded from `models.dev`

## Live config-watching


## Simplified keystore sematics

* Per-daemon keystore unlock keys with hardened per-daemon keystore state
* Unlock UX rework — /unlock uses the stored key; /unlock <key> records it; identity.pk.enc removed entirely
* BindKeystore as the sole binding path — Unlock/AddCredential are verify-only, fresh keys only for bind (0da7e58); frontend auto-bind: TUI/GUI/IM bind fresh unbound daemons and confirm on Bound (4d84ffc); documented binding model + ordering invariant (646977e); shared auto-bind state machine with choreo-im flow tests (9ab23b7)
* Client access-control & trust model — Noise XX first-contact mode with TCP wire v5 handshake preamble (78de9a1), fingerprint rendering + known_servers.toml pin store (3f69fb3), pinned-mode trust flow with fingerprint confirmation (8954694), hot-reloaded client ACL from authorized_clients.toml (356e505), /acl add enrollment from a local connection (f2bb40c), choreographr acl-add and fingerprint subcommands (4d49ce4), tightened fingerprint compare + pinned-mode failure UX (40a38e3); trust model documented in ARCHITECTURE.md (888c4c7)
* TUI refuses to start unauthorized daemons and never crashes on connection errors

## Other

* Brotli response decompression in ureq HTTP (9234975)
* Tool-output safety: new choreo-sanitize crate fixing six tool-output safety gaps (f8e2495); harmonized sanitization and bounded streaming across all tools (b995877)
* Shell tools can raise the outer deadline above the 300s floor (03571d1)
* Improved OpenCode gateway compatibility.
* Choreographr user agent string on LLM requests.
* Background model prefetch — model lists warmed on session join instead of at unlock, never blocking ListModels (6b4afb7, 43fcc7c)
* glm-5.3-flash added to opencode overlay
* zstd compression of session_turns database table

Building on the
[v0.1.0 release](@/blog/choreographr-0-1-0.md), this release
adds <!-- TODO: headline features, e.g. subsessions, Git worktrees, cron, extensions, OS-level sandboxing, Solana tools -->.

## TODO: Headline feature one

<!-- TODO: explain the feature, show a short `choreo-tui` session or code snippet. -->

## TODO: Headline feature two

<!-- TODO: same treatment. -->

## Also in this release

<!-- TODO: bullet list of smaller features, fixes and performance work. -->

- <!-- TODO -->

## Upgrading

Prebuilt binaries for macOS and Linux as before — see the
[installation guide](@/agent/docs/installation.md). If you're coming from
v0.1.0, <!-- TODO: note any breaking changes or config migration steps, or say nothing changes -->.

Full release notes: [v0.2.0 on GitHub](https://github.com/choreographr/choreographr/releases).

We'd love your help — star the
[repo](https://github.com/choreographr/choreographr), open
[issues](https://github.com/choreographr/choreographr/issues), and join the
[Telegram community](https://t.me/choreographr).
