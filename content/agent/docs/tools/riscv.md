+++
title = "RISC-V VM tool"
description = "run_riscv: compile and run Rust code in a sandboxed RISC-V VM."
weight = 9
+++

The `vm` group contains `run_riscv`, which compiles and runs Rust code in a
sandboxed RISC-V VM (powered by [CKB VM](https://github.com/nervosnetwork/ckb-vm)) —
either a `source` snippet or pre-compiled bytecode:

| Argument | Meaning |
|---|---|
| `source` | A `fn main()` body; the tool auto-generates `#![no_std]`, `#[panic_handler]`, `_start`, and the `choreo` module |
| `program` | Base64-encoded ELF compiled with the choreographr syscall ABI |
| `program_path` | Path to an ELF file on disk (same ABI) |
| `args` | Program arguments passed to the guest |
| `max_cycles` | Cycle budget (default is documented in the tool schema) |
| `memory_size` | Guest memory size |

```json
{ "name": "run_riscv", "arguments": { "source": "let n = 40; let r = choreo::http_request(\"GET\", \"https://api.example.com\", &[], None, None); choreo::write(r.as_bytes());" } }
```

The VM is a complete, observable replacement for the shell: all tool access
goes through the same `ToolRegistry` as the host agent, with the same
credentials and working directory — but inside an isolated single-hart VM with
no host memory, syscalls, or filesystem access except through registered
tools. Guests use the `choreo` convenience wrappers (which handle postcard
encoding automatically):

```rust
choreo::read_file(path)                          // -> String
choreo::write_file(path, content, overwrite)
choreo::db_get(key)                              // -> Vec<u8>
choreo::db_set(key, value)                       // value: &[u8]
choreo::db_delete(key)                           // -> bool
choreo::sh(command, shell, workdir, timeout_ms)  // -> String
choreo::exec(command, args, workdir, timeout_ms) // -> String
choreo::grep(pattern, regex, include, path, max_results)
choreo::find(pattern, glob, path, max_results)
choreo::http_request(method, url, headers, body, timeout_secs)
choreo::write(bytes)                             // VM stdout
choreo::exit(code)
```

> Notes: the A (atomic) extension is disabled, so guests must not use
> `core::sync::atomic` read-modify-write operations. For `grep`, set
> `regex: true` when using regex patterns (the default is literal matching).

To compile a `source` snippet, the daemon shells out to
`rustc +stable --target riscv64imac-unknown-none-elf`, so the RISC-V
bare-metal target must be installed on the host (`rustup target add
riscv64imac-unknown-none-elf` — see
[Installation](@/agent/docs/installation.md#risc-v-vm-tooling)).

> Use `choreo::write(...)` for VM output and `choreo::exit(code)` to finish.
