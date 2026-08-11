+++
title = "Concepts"
description = "Sessions, subsessions, tools, tool groups, skills, and the RISC-V VM."
weight = 6
+++

This page introduces the core concepts you'll meet when using and extending
Choreographr.

## Agent loop (harness)

The daemon drives a server-side loop that repeatedly sends conversation history
and available tools to the LLM, executes any tool calls the model requests,
appends the results, and loops until the model produces a final answer, is
cancelled, or hits an error (subject to the daemon-wide iteration cap; `0` =
unlimited). Each session keeps a responsive control thread and runs request
work in a separate worker thread. The client only sees
`ToolCallStarted` / `ToolCallFinished` lifecycle events.

## Sessions & subsessions

A **session** is a persisted conversation with its own message history, model,
and working directory. Sessions:

- form a parent-child tree,
- support multiple concurrent client attachments,
- survive daemon restarts via the embedded `redb` database,
- are only "woken up" when a client connects to them.

A **subsession** is a child session spawned by the `spawn_subsession` tool. It
inherits the parent's working directory, runs its own full agent loop
independently, and returns its output as the parent's tool result. Subsessions
persist permanently, and they can spawn their own subsessions.

## Tools

A **tool** is a function the LLM can call to interact with the outside world —
read files, make HTTP requests, run git commands, query blockchains, post to X,
and so on. Tools implement the `Tool` trait (name, group, description, JSON
Schema, `execute`) and are registered in a `ToolRegistry` at daemon startup.
Every tool also provides a human-readable invocation description.

See the [tools reference](@/docs/tools.md) for the complete, up-to-date list
of every built-in tool and how to call it.

Available tool groups include **core** (filesystem, HTTP, images, PDF
classification, search, random, time), **git**, **shell**, **vm**, **x**,
**db**, and **blockchain** (EVM and Substrate/Polkadot queries,
when the daemon is built with the `blockchain` feature). Only `core`,
`git`, and `shell` are active by default.

### Tool groups

Tools are organized into groups to reduce context overhead. The model can
activate additional groups with `load_tools` and deactivate them with
`unload_tools`. Groups are a **discovery mechanism, not access control** — the
RISC-V VM always has access to all tools.

## Skills

Skills follow the Agent Skills standard — a `SKILL.md` file with YAML
frontmatter (`name`, `description`) placed under `.agents/skills/<name>/` or
`~/.agents/skills/<name>/`. At session creation, skill names and descriptions
are listed in the system prompt. When the model calls `load_skill`, the full
instruction body is injected into the conversation (progressive disclosure).

## RISC-V virtual machine

The LLM can invoke the RISC-V VM (powered by [CKB VM](https://github.com/nervosnetwork/ckb-vm))
by providing a Rust snippet or pre-compiled bytecode. This has two main
purposes:

- **a tool-call scripting language** — the LLM can quickly write a little script
  to call tools with custom logic;
- **a complete replacement for the shell tool** — giving the LLM direct shell
  access is dangerous. Disabling the shell tool and doing everything via the VM
  provides complete control and observability.

The guest runs in an isolated VM with 4 MB of flat memory. All tool access goes
through the same `ToolRegistry` as the host agent, respecting the same
credentials and working directory. The guest cannot access host memory,
syscalls, or files outside the VM without going through registered tools.

## Agent databases

LLMs can create persistent key/value databases. The LLM / VM can store data and
retrieve it later — data survives restarts.

## Multiple live sessions

Each server can run multiple sessions simultaneously (limited only by system
resources). Rather than a multi-session terminal multiplexor, you manage all
your sessions directly from a client program. Sessions have undo/redo
functionality: if an LLM is mis-prompted, it's often better to remove the
prompt than to prompt more to try to "fix it".

## Context files

The daemon automatically discovers project context files (`AGENTS.md`,
`CLAUDE.md`) and skills at session creation, and refreshes them before every
model call via fingerprint-based caching. Subdirectory hints are appended to
tool results when filesystem tools dive into subdirectories that contain their
own context files.
