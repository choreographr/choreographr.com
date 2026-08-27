+++
title = "Diagnostic tools"
description = "Read-only diagnostics: session_inspect, the reasoning-echo dry-run."
weight = 8
+++

The `debug` group holds read-only diagnostics and request dry-runs. It is not
active by default — activate it with `load_tools debug`.

| Tool | What it does |
|---|---|
| `session_inspect` | Read-only reasoning-echo diagnostic: dry-runs the request the daemon would build for a session and reports which assistant turns carry the provider's reasoning field on the wire and which would be sent bare (the DeepSeek/Kimi 400 "reasoning_content must be passed back" risk) |

`session_inspect` takes optional `session_id` (defaults to the calling
session), `provider` / `model` overrides, `include_raw` (own session only), and
`max_turns` (default 512). It is faithful — it uses the same code paths as the
agent loop, so the report is a dry-run, not a reimplementation. Privacy mirrors
the codebase's thinking-content invariant: artifact metadata and producer
identity are reported for any session, but message-text previews and raw
reasoning bytes are only rendered for the calling session.

```json
{ "name": "session_inspect", "arguments": { "include_raw": true } }
```
