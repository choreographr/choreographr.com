+++
title = "Security"
description = "Lock/unlock, encrypted credentials, and the RISC-V sandbox."
weight = 10
+++

Choreographr takes a defense-in-depth approach to security.

## Lock / unlock flow

The daemon starts in a **locked** state — no credentials in memory. Each
daemon has its own **keystore unlock key**: the first client to **bind**
(`BindKeystore`) a fresh, unbound daemon generates the key and stores it in
the daemon's keystore. After that, `/unlock` uses the stored key directly, and
`/unlock <key>` records the key when unlocking an already-bound daemon, so the
private key never has to be entered again.

The daemon's keystore has **three states** — `Unbound` (no binding yet),
`Locked` (bound, no cleartext in memory), and `Unlocked`. The daemon is the
authoritative source of this status: it pushes the current state to a client
the moment the client connects and broadcasts each transition to every
subscribed client, so the UI never has to infer the lock state from operation
replies. A first-run client learns the daemon is unbound from this push and
auto-binds immediately — a fresh daemon is never a dead end.

- Credentials are encrypted **per-credential** with ECDH (X25519) + HKDF +
  AES-256-GCM; only the holder of the private key can decrypt them.
- Binding goes through `BindKeystore` only — `Unlock` and `AddCredential` are
  **verify-only** (they check a key against the bound keystore; they never
  install a new one).
- Frontends auto-bind a fresh, unbound daemon and confirm once it reports
  `Bound`. A client that connects with no stored key mints one and probes with
  a verify-only `BindKeystore` — an already-bound daemon never gets its
  binding overwritten; a fresh one is adopted. Auto-binding is triggered by
  the daemon's authoritative unbound status push, so it works on a genuine
  first run (where neither the client nor the daemon has ever seen a key).
- `/lock` destroys all in-memory credentials and returns the daemon to the
  locked state. An unlock that fails partway (e.g. a corrupt accounts file)
  commits nothing — every fallible step runs on local state first, so
  freshly decrypted credentials can never leak into a daemon that still
  reports itself locked.
- The private key is zeroized after use.
- Lock/unlock does not interrupt session browsing — credentials are only needed
  at prompt time.
- Remote connections (over TCP) use a **Noise** handshake with X25519 key
  agreement — **IK** when the server's key is pinned, and **XX** first-contact
  mode when it is not (see [Client trust & access control](#client-trust-access-control)).

## Credential storage

| Item | Location |
|---|---|
| Transport secret key | `~/.config/choreographr/transport.sec` |
| Transport public key | `~/.config/choreographr/transport.pub` |
| Encrypted credentials | `redb` database (`~/.local/share/choreographr/state.redb`) |
| Keystore unlock key | stored in the daemon's keystore (see [Lock / unlock flow](#lock-unlock-flow)) |
| Pinned servers | `~/.config/choreographr/known_servers.toml` |
| Authorized clients | `~/.config/choreographr/authorized_clients.toml` |

Credentials are encrypted per-credential with the daemon's X25519 public key,
so the encrypted blobs are useless without the private key.

A credential enters through the daemon, never around it: the client sends a
**typed** credential value (API key, X tokens, or OAuth grant) and the daemon
encrypts it to its own binding public key before it touches disk, so no key
material rides the add path. An add requires an already-unlocked keystore — a
locked daemon refuses it rather than unlocking itself.

## Owner-only local trust

The Unix socket is the daemon's fully-trusted local domain: it carries no Noise
handshake, so a peer that reaches it can read transcripts, retrieve credentials
while the keystore is unlocked, run tools, and enroll other clients. It is
created **`0600` inside a directory only its owner can traverse** — a
`--base-dir`'s `run/`, or a per-uid `temp_dir()/choreographr-<uid>` when neither
`$XDG_RUNTIME_DIR` nor a base dir is set, so parallel users on a shared `/tmp`
neither collide nor share a parent.

The `redb` store (plaintext transcripts and tool output), `known_servers.toml`
(the per-daemon private unlock keys), and the log files are owner-only too, and
the policy lives in one place (`choreo_shared::perm`) instead of three drifting
copies. Two hardening details matter:

- `known_servers.toml` is opened `O_NOFOLLOW` and owner-checked **before** it is
  parsed. A `pubkey` pin steers the next Noise IK handshake, so a planted file
  could otherwise pin an attacker's server and capture credentials. A refused
  file degrades to the empty store (re-confirmed first contact).
- A directory owned by another user is **refused outright** rather than warned
  about and used anyway — a foreign-owned directory lets that user enumerate or
  swap the socket and store files. Private modes are applied through an
  `O_NOFOLLOW` directory descriptor (`fchmod`), not a path chmod.

Logs are written as a pid-keyed file per binary, pruned **by age** (one week)
rather than by count, and they never contain payloads: prompts, model output,
tool arguments and results, and credentials are logged as ids, kinds, lengths,
and counts instead.

## Client trust & access control

Remote connections are mutually authenticated. On first contact — before the
server's public key is pinned — the client uses Noise **XX**: the handshake
carries the server's static key, which the client renders as a **fingerprint**
for out-of-band confirmation and records in `known_servers.toml`. Later
connections use Noise **IK** against the pinned key, and a mismatch is refused
with a clear failure rather than a silent reconnect.

The daemon also keeps a client **allow-list** in `authorized_clients.toml`,
hot-reloaded from disk. A client with no local access can be enrolled with
`/acl add` from an already-authorized connection, or with the
`choreographr acl-add` subcommand; `choreographr fingerprint` prints the
daemon's own fingerprint. The TUI refuses to start against an unauthorized
daemon and never crashes on a connection error.

## MCP servers

MCP (Model Context Protocol) servers are configured in two tiers: a
daemon-wide `mcp.json` you wrote and trust unconditionally, and a project
`.mcp.json` that travels with a checkout you may not have written. A project's
servers are **gated behind trust** — read (so `/mcp status` can report what is
ignored) but never spawned, and their `${VAR}` references never expanded, until
you run `/mcp trust` for that project root (recorded in `trust.toml`, keyed on
the exact root). Revoking trust drops that project's live connections
immediately.

A stdio server inherits the daemon's environment with the
code-injection variables (`LD_*`, `DYLD_*`, `PYTHONPATH`, `PERL5LIB`,
`RUBYLIB`) stripped, its `stderr` is captured to an owner-only per-server log,
and its calls are deadline-bounded and concurrency-capped.

A server that needs an interactive sign-in stores an OAuth grant in the same
encrypted keystore as provider credentials, **keyed by the server's target**
(`mcp:<slug>|<target-hash>`) so a same-slug server on a different endpoint keeps
its own credential. Two things fail closed: a project server's sign-in is
refused while that project root is untrusted (its `oauth` block is
repo-controlled), and a stored grant whose issuer or resource no longer matches
the configured server is treated as absent and surfaces a re-login. A
confidential client's secret comes from an environment variable named by
`clientSecretEnv`, never from the config file.

## RISC-V sandbox

The `run_riscv` tool compiles Rust source (or accepts a pre-compiled RISC-V
ELF) and executes it inside an isolated `ckb-vm` machine with:

- a 4 MB flat memory space (ckb-vm's maximum),
- a configurable cycle budget (default 10M),
- a custom syscall handler for tool dispatch,
- a `#![no_std]` guest with a linked-list allocator and `tool_call` / `write` /
  `exit` syscalls.

The guest cannot access host memory, syscalls, or files outside the VM without
going through registered tools. The VM respects the same credentials and
working directory as the host agent.

## Untrusted text on a terminal

Model output, tool output, tool names, session titles, and pasted text are all
potentially hostile strings, and a terminal is an escape-sequence interpreter.
`choreo-tui` normalizes every displayed string at its widget sink — control
characters and escape sequences are removed, so model output cannot emit
terminal commands — and strips **bidirectional-formatting** controls
(RLO/LRO, isolates, LRM/RLM/ALM) from the free-text fields it writes back out:
the OSC 2 window title and the OSC 7501 program-status record, both of which
would otherwise let a hostile session title reorder or spoof what you see.
Zero-width joiners are kept, so emoji sequences still render.

## OS-level sandboxing (planned)

While the VM itself is a perfect sandbox, tools are executed outside of it (for
example, if the shell tool is enabled). An OS-level sandbox is planned:

- **Linux** — [Landlock](https://landlock.io/)
- **macOS** — [Seatbelt](https://theapplewiki.com/wiki/Dev:Seatbelt)

## Vision & web-page inputs

- **`read_image`** — reads a local image file, normalizes it, and feeds it to a
  vision model. The normalized bytes are persisted durably in the
  `session_attachments` table so they survive restarts. Only local file paths
  are accepted (URLs / clipboard paste are future work).
- **`retrieve_webpage`** — renders a URL in a headless Chromium/Chrome launched
  by the daemon. It accepts `http`, `https`, and `file` schemes; a `file://`
  URL lets the browser read arbitrary local files from the daemon's host. That
  reach is intentional — the browser runs with the daemon's own privileges
  (OS-level sandboxing is still planned; see below) — so `file://` input should
  be treated as equivalent to reading a local file.

## Best practices

- Keep the shell tool disabled and do everything through the VM for maximum
  control and observability.
- Bind and unlock the daemon once; the per-daemon keystore key is stored, so
  the private key is not re-entered on every start.
- Lock the daemon (`/lock`) when you're done for the day.
- Gate the sensitive `debug` / `blockchain` groups behind `load_tools`; only
  `core`, `git`, and `shell` are active by default.
