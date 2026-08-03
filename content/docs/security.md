+++
title = "Security"
description = "Lock/unlock, encrypted credentials, and the RISC-V sandbox."
weight = 8
+++

Choreographr takes a defense-in-depth approach to security.

## Lock / unlock flow

The daemon starts in a **locked** state — no credentials in memory. The client
resolves the private key (reading `identity.pk` directly, or decrypting
`identity.pk.enc` with a passphrase) and sends it to the daemon via
`ClientMessage::Unlock`. The daemon then decrypts all stored credential blobs
into memory.

- Credentials are encrypted **per-credential** with ECDH (X25519) + HKDF +
  AES-256-GCM; only the holder of the private key can decrypt them.
- `/lock` destroys all in-memory credentials and returns the daemon to the
  locked state.
- The private key is zeroized after use.
- Lock/unlock does not interrupt session browsing — credentials are only needed
  at prompt time.
- Remote connections (over TCP) use the **Noise IK** handshake with X25519 key
  agreement, giving an authenticated, encrypted transport.

## Credential storage

| Item | Location |
|---|---|
| Identity private key | `~/.config/choreographr/identity.pk` (or passphrase-encrypted `identity.pk.enc`) |
| Identity public key | `~/.config/choreographr/public.pk` |
| Encrypted credentials | `redb` database (`~/.local/share/choreographr/state.redb`) |

Credentials are encrypted per-credential with the daemon's X25519 public key,
so the encrypted blobs are useless without the private key.

## RISC-V sandbox

The `run_riscv` tool compiles Rust source (or accepts pre-compiled bytecode)
and executes it inside an isolated `ckb-vm` machine with:

- a 4 MB flat memory space (ckb-vm's maximum),
- a configurable cycle budget (default 10M),
- a custom syscall handler for tool dispatch,
- a `#![no_std]` guest with a linked-list allocator and `tool_call` / `write` /
  `exit` syscalls.

The guest cannot access host memory, syscalls, or files outside the VM without
going through registered tools. The VM respects the same credentials and
working directory as the host agent.

## OS-level sandboxing (planned)

While the VM itself is a perfect sandbox, tools are executed outside of it (for
example, if the shell tool is enabled). An OS-level sandbox is planned:

- **Linux** — [Landlock](https://landlock.io/)
- **macOS** — [Seatbelt](https://theapplewiki.com/wiki/Dev:Seatbelt)

## Best practices

- Keep the shell tool disabled and do everything through the VM for maximum
  control and observability.
- Use `identity.pk.enc` with a strong passphrase for the private key at rest.
- Lock the daemon (`/lock`) when you're done for the day.
