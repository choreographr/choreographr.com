+++
title = "Installation"
description = "Build Choreographr from source and install the binaries with Cargo."
weight = 1
+++

## Build from source

Requires a [Rust toolchain](https://rustup.rs/) — the minimum supported Rust
version (MSRV) is **1.91** — and a [Zig](https://ziglang.org/) toolchain, which
is needed to build the RISC-V VM components.

Install Zig from [ziglang.org](https://ziglang.org/) (or your package manager
— e.g. `brew install zig`, `apt install zig`, `pacman -S zig`), then check out
the project from GitHub:

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
