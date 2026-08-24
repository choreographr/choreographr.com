+++
title = "Testing & development"
description = "Running the test suite, lints, and formatting."
weight = 12
+++

```bash
cargo test                  # unit tests
cargo test -- --ignored     # integration tests
cargo clippy --workspace    # lints
cargo fmt --all             # formatting
```

The workspace targets an MSRV of **1.91**, declared via `rust-version` in every
crate manifest. Keep code and dependencies within this floor.

## Test infrastructure

Tests use `UnixStream::pair()` for socket-less daemon↔client communication, and
mock HTTP servers for API simulation. Test coverage spans the protocol layer,
client core, daemon lifecycle, MCP integration, provider clients (SSE parsing,
request construction, catalog lookups), and the TUI/GUI app state.

See `ARCHITECTURE.md` for the full test matrix.
