+++
title = "Monitoring"
description = "Prometheus / OpenMetrics endpoint and the exposed metrics."
weight = 11
+++

The daemon can expose an OpenMetrics (Prometheus) endpoint:

```bash
cargo run --release -p choreo-daemon -- --metrics-addr 127.0.0.1:9464
```

When `--metrics-addr` is provided, a dedicated HTTP thread serves `GET /metrics`
at the given address. Without the flag, no metrics server is started.

## Metrics

| Metric | Type | Labels | Description |
|---|---|---|---|
| `choreo_sessions_active` | Gauge | — | Active sessions |
| `choreo_connections_active` | Gauge | — | Active client connections |
| `choreo_requests_total` | Counter | `status` | Requests processed |
| `choreo_tool_executions_total` | Counter | `tool`, `status` | Tool call count |
| `choreo_api_calls_total` | Counter | `model`, `endpoint` | API call count |
| `choreo_api_errors_total` | Counter | `model`, `error_type` | API error breakdown |
| `choreo_connections_total` | Counter | — | Total connections accepted |
| `choreo_turns_total` | Counter | `model` | Agent loop turns |
| `choreo_request_duration_seconds` | Histogram | `status` | Request latency |
| `choreo_tool_execution_duration_seconds` | Histogram | `tool` | Per-tool execution time |
| `choreo_api_call_duration_seconds` | Histogram | `model`, `endpoint` | API round-trip time |

Process-level metrics (RSS, CPU, FD count) are also exposed via the
`prometheus` crate's `process` feature.

All operations are atomic (no locks), and a dedicated thread serves the
endpoint via `tiny_http`, polling the shutdown flag every second.
