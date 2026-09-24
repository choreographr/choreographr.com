+++
title = "Installation"
description = "Install Choreographr with Homebrew, a .deb or .rpm, a manual tarball download, cargo-binstall, or a Cargo build."
weight = 1
+++

Every release ships **two prebuilt binaries** — `choreographr` (the daemon)
and `choreo-tui` (the terminal client) — for **Linux (x86_64 and arm64)**,
**macOS (Apple Silicon and Intel)**, and **Android (Termux)**. All install
routes below use these
binaries except the Cargo source build; none of them need a Rust toolchain at
install time.

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

[Download](https://github.com/choreographr/choreographr/releases/download/v0.2.3/choreographr-0.2.3-aarch64-apple-darwin.tar.gz) the Apple Silicon tarball, or run:

```bash
curl -fL -O https://github.com/choreographr/choreographr/releases/download/v0.2.3/choreographr-0.2.3-aarch64-apple-darwin.tar.gz
tar xzf choreographr-0.2.3-aarch64-apple-darwin.tar.gz
sudo cp choreographr choreo-tui /usr/local/bin/
```

[Download](https://github.com/choreographr/choreographr/releases/download/v0.2.3/choreographr-0.2.3-x86_64-apple-darwin.tar.gz) the Intel (x86_64) tarball, or run:

```bash
curl -fL -O https://github.com/choreographr/choreographr/releases/download/v0.2.3/choreographr-0.2.3-x86_64-apple-darwin.tar.gz
tar xzf choreographr-0.2.3-x86_64-apple-darwin.tar.gz
sudo cp choreographr choreo-tui /usr/local/bin/
```

The binaries are unsigned, so Gatekeeper quarantines them — clear the
attribute after extracting:

```bash
xattr -dr com.apple.quarantine /path/to/choreographr
```

## Linux

### Debian / Ubuntu — .deb

[Download](https://github.com/choreographr/choreographr/releases/download/v0.2.3/choreographr-0.2.3-x86_64.deb) the x86_64 package (or the [aarch64 package](https://github.com/choreographr/choreographr/releases/download/v0.2.3/choreographr-0.2.3-aarch64.deb) on arm64), or run:

```bash
curl -fL -O https://github.com/choreographr/choreographr/releases/download/v0.2.3/choreographr-0.2.3-x86_64.deb
sudo apt install ./choreographr-0.2.3-x86_64.deb
```

On an arm64 host, fetch `choreographr-0.2.3-aarch64.deb` instead.

### Fedora / RHEL / openSUSE — .rpm

[Download](https://github.com/choreographr/choreographr/releases/download/v0.2.3/choreographr-0.2.3-x86_64.rpm) the x86_64 package (or the [aarch64 package](https://github.com/choreographr/choreographr/releases/download/v0.2.3/choreographr-0.2.3-aarch64.rpm) on arm64), or run:

```bash
curl -fL -O https://github.com/choreographr/choreographr/releases/download/v0.2.3/choreographr-0.2.3-x86_64.rpm
sudo dnf install ./choreographr-0.2.3-x86_64.rpm
```

On an arm64 host, fetch `choreographr-0.2.3-aarch64.rpm` instead.

Both packages install the two binaries and the systemd user unit
(`~/.config/systemd/user/choreographr.service`).

### Any distro — manual tarball

The Linux tarball is a **fully static musl build**, so one artifact runs on
any Linux distribution regardless of glibc version. [Download](https://github.com/choreographr/choreographr/releases/download/v0.2.3/choreographr-0.2.3-x86_64-unknown-linux-musl.tar.gz) it, or run:

```bash
curl -fL -O https://github.com/choreographr/choreographr/releases/download/v0.2.3/choreographr-0.2.3-x86_64-unknown-linux-musl.tar.gz
tar xzf choreographr-0.2.3-x86_64-unknown-linux-musl.tar.gz
sudo cp choreographr choreo-tui /usr/local/bin/
```

On arm64, fetch `choreographr-0.2.3-aarch64-unknown-linux-musl.tar.gz` instead.

## Android (Termux)

The daemon and TUI ship for **Termux on Android 10+** as a Termux-native
`.deb`. [Download](https://github.com/choreographr/choreographr/releases/download/v0.2.3/choreographr-termux_0.2.3_aarch64.deb) it, or install it inside a Termux shell with `pkg`:

```bash
curl -fL -O https://github.com/choreographr/choreographr/releases/download/v0.2.3/choreographr-termux_0.2.3_aarch64.deb
pkg install ./choreographr-termux_0.2.3_aarch64.deb
```

It installs `choreographr` and `choreo-tui` under Termux's `$PREFIX`.

## Any platform — cargo-binstall

[`cargo-binstall`](https://github.com/cargo-bins/cargo-binstall) installs the
prebuilt release binaries without a Rust toolchain — a one-line alternative to
the manual tarball on macOS and Linux. Install `cargo-binstall` first (a
prebuilt binary is available from its
[releases](https://github.com/cargo-bins/cargo-binstall/releases)), then:

```bash
cargo binstall choreographr choreo-tui
```

binstall reads the `[package.metadata.binstall]` metadata declared by each
crate, resolves the matching GitHub release asset for your platform (on glibc
Linux it uses the static musl tarball), verifies its checksum, and installs the
binary that crate provides.

## From source with Cargo

```bash
cargo install choreographr choreo-tui --locked
```

This builds the daemon and the terminal client from crates.io.

Requirements: a [Rust toolchain](https://rustup.rs/) — minimum supported Rust
version (MSRV) is **1.95.0** — and a **Zig** toolchain on your `PATH`.
Zig compiles the [`zlob`](https://crates.io/crates/zlob) crate, a
SIMD-accelerated globbing and file-walking library that powers the agent's
`find`, `grep`, and related file tools; its build script compiles Zig source
at build time. Install Zig from [ziglang.org](https://ziglang.org/download/)
(or your package manager — e.g. `brew install zig`, `apt install zig`,
`pacman -S zig`).

## Blockchain tools

The EVM and Substrate/Polkadot blockchain tools (`evm_*`, `subxt_*` — see the
[tools reference](@/agent/docs/tools/blockchain.md)) are compiled in behind the
`blockchain` cargo feature. The release binaries enable it; when building from
source, opt in explicitly:

```bash
cargo install choreographr --locked --features blockchain
```

The tools live in the optional [`choreo-blockchain`](https://github.com/choreographr/choreographr/tree/master/choreo-blockchain)
crate — the only workspace crate that depends on `tokio` — so a build without
the feature compiles the whole alloy/subxt/tokio tree out. Once the daemon is
running, activate the group per session with `load_tools blockchain`.

## RISC-V VM tooling

The [`run_riscv`](@/agent/docs/tools/riscv.md) tool compiles guest Rust
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

## Web page rendering

The [`retrieve_webpage`](@/agent/docs/tools/core.md#retrieve-webpage)
tool needs a **Chromium or Chrome binary installed on the host** — it does not
auto-download a browser. It prefers `chromium` on your `PATH`, then the various
Chrome bundles, and honors `CHROMIUM_BIN` / `CHROME_BIN` to point at a specific
path. Install it via your package manager (e.g. `apt install chromium`,
`brew install --cask chromium`).

Ready to chat? Head over to the [quick start](@/agent/docs/quick-start.md).
