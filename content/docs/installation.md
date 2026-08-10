+++
title = "Installation"
description = "Install Choreographr with Homebrew, a .deb or .rpm, a manual tarball download, or a Cargo build."
weight = 1
+++

Every release ships **four prebuilt binaries** — `choreographr` (the daemon),
`choreo-tui` (the terminal client), `choreo-im` (the IM bridge), and
`choreo-acp` (the ACP bridge) — for **Linux x86_64** and **macOS (Apple
Silicon)**. All install routes below use these binaries except the Cargo
source build; none of them need a Rust toolchain at install time.

## macOS

### Homebrew

The `choreographr/choreographr` tap provides a prebuilt formula — no
toolchain needed:

```bash
brew tap choreographr/choreographr
brew trust choreographr/choreographr
brew install choreographr
```

Homebrew 6.0 and later refuse to load non-official taps until they are
explicitly trusted (loading a tap can run Ruby code from it) — that's what
the `brew trust` step is for.

### Manual tarball

Download and extract the Apple Silicon tarball, then put the four binaries
on your `PATH`:

```bash
curl -fL -O https://github.com/choreographr/choreographr/releases/download/v0.1.0/choreographr-0.1.0-aarch64-apple-darwin.tar.gz
tar xzf choreographr-0.1.0-aarch64-apple-darwin.tar.gz
sudo cp choreographr choreo-tui choreo-im choreo-acp /usr/local/bin/
```

The binaries are unsigned, so Gatekeeper quarantines them — clear the
attribute after extracting:

```bash
xattr -dr com.apple.quarantine /path/to/choreographr
```

## Linux

### Debian / Ubuntu — .deb

```bash
curl -fL -O https://github.com/choreographr/choreographr/releases/download/v0.1.0/choreographr-0.1.0-x86_64.deb
sudo apt install ./choreographr-0.1.0-x86_64.deb
```

### Fedora / RHEL / openSUSE — .rpm

```bash
curl -fL -O https://github.com/choreographr/choreographr/releases/download/v0.1.0/choreographr-0.1.0-x86_64.rpm
sudo dnf install ./choreographr-0.1.0-x86_64.rpm
```

Both packages install the four binaries and the systemd user unit
(`~/.config/systemd/user/choreographr.service`).

### Any distro — manual tarball

The Linux tarball is a **fully static musl build**, so one artifact runs on
any Linux distribution regardless of glibc version:

```bash
curl -fL -O https://github.com/choreographr/choreographr/releases/download/v0.1.0/choreographr-0.1.0-x86_64-unknown-linux-musl.tar.gz
tar xzf choreographr-0.1.0-x86_64-unknown-linux-musl.tar.gz
sudo cp choreographr choreo-tui choreo-im choreo-acp /usr/local/bin/
```

## From source with Cargo

`cargo install choreographr --locked` builds the whole suite from crates.io:

```bash
cargo install choreographr --locked
```

Requirements: a [Rust toolchain](https://rustup.rs/) — minimum supported Rust
version (MSRV) is **1.91** — and a **Zig 0.16.0** toolchain on your `PATH`.
Zig compiles the [`zlob`](https://crates.io/crates/zlob) crate, a
SIMD-accelerated globbing and file-walking library that powers the agent's
`find`, `grep`, and related file tools; its build script compiles Zig source
at build time. Install Zig 0.16.0 from [ziglang.org](https://ziglang.org/download/)
(or your package manager — e.g. `brew install zig`, `apt install zig`,
`pacman -S zig`).

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
