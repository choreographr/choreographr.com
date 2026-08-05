+++
title = "Installation"
description = "Build Choreographr from source and install the binaries with Cargo."
weight = 1
+++

## Build from source

Requires a [Rust toolchain](https://rustup.rs/) — the minimum supported Rust
version (MSRV) is **1.91** — and a **Zig 0.16.0** toolchain. Zig is needed to
compile the [`zlob`](https://crates.io/crates/zlob) crate, a SIMD-accelerated
globbing and file-walking library written in Zig that powers the agent's
`find`, `grep`, and related file tools. Its build script compiles Zig source
at build time, so `zig` must be on your `PATH`.

Install Zig 0.16.0 from [ziglang.org](https://ziglang.org/download/) (or your
package manager — e.g. `brew install zig`, `apt install zig`, `pacman -S zig`),
then check out the project from GitHub:

```bash
git clone https://github.com/ethernomad/choreographr
cd choreographr
```

Build and install the binaries with Cargo:

```bash
cargo install --path choreo-daemon --locked
cargo install --path choreo-tui --locked
```

This puts `choreographr` (the daemon) and `choreo-tui` (the terminal client)
on your `PATH`, typically in `~/.cargo/bin`.

Ready to chat? Head over to the [quick start](@/docs/quick-start.md).
