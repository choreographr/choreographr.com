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

## RISC-V VM tooling

The [`run_riscv`](@/docs/tools.md#risc-v-vm-tool) tool compiles guest Rust
programs **at runtime**, so the daemon needs the RISC-V bare-metal target
installed for its stable toolchain:

```bash
rustup target add riscv64imac-unknown-none-elf
```

If your default toolchain isn't `stable`, add it explicitly:

```bash
rustup target add riscv64imac-unknown-none-elf --toolchain stable
```

The daemon invokes `rustc +stable --target riscv64imac-unknown-none-elf`
whenever a `run_riscv` call passes a `source` snippet, so the target must be
installed wherever the daemon runs. Passing pre-compiled bytecode
(`program` / `program_path`) doesn't require it.

Ready to chat? Head over to the [quick start](@/docs/quick-start.md).
