+++
title = "Testing & development"
description = "Running the test suite, lints, and formatting."
weight = 12
+++

The recommended test runner is **cargo-nextest** (`cargo install cargo-nextest`),
wrapped by cargo aliases:

```bash
cargo test-fast           # unit tests (nextest; one process per test)
cargo test-lean           # unit tests with every optional feature off
cargo test-integration    # integration tests — the #[ignore] suite
cargo test-all            # unit + integration in one pass
```

Without nextest, the same suites run through plain libtest:

```bash
cargo test                # unit tests
cargo test -- --ignored   # integration tests
```

And regardless of the runner:

```bash
cargo clippy --workspace --all-targets   # lints
cargo fmt --all                          # formatting
```

The repo builds on **nightly** Rust by default (`rust-toolchain.toml`), so every
`cargo` command picks up fast per-profile `-Z` flags automatically; stable is a
supported opt-out via the `just build-stable` / `test-stable` recipes.

The workspace targets an MSRV of **1.99.0**, declared via `rust-version` in every
crate manifest (inherited from `[workspace.package]`). Keep code and dependencies
within this floor.

## Test infrastructure

Tests use `UnixStream::pair()` for socket-less daemon↔client communication, and
mock HTTP servers for API simulation. Test coverage spans the protocol layer,
client core, daemon lifecycle, provider clients (SSE parsing,
request construction, catalog lookups), and the TUI/GUI app state.

See `ARCHITECTURE.md` for the test-runner and infrastructure details.
