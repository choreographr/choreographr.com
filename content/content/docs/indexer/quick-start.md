+++
title = "Quick Start"
description = "One page summary of how to get started with Acuity Index."
date = 2021-05-01T08:20:00+00:00
updated = 2021-05-01T08:20:00+00:00
draft = false
weight = 60
template = "content-doc.html"

+++

## 1. Generate A Starter Spec

```bash
acuity-index generate-index-spec ./mychain.toml --url wss://mynode:443
```

This inspects live runtime metadata and writes a starter TOML file.

## 2. Review And Edit The Spec

Remove any unneccesary keys.

Add compound keys as necessary.

See the configuration section for complete index spec schema.

## 3. Run The Indexer

```bash
acuity-index run ./mychain.toml
```

Common overrides:

```bash
acuity-index run ./mychain.toml --url wss://mynode:443 --queue-depth 4 --port 8172
```

Greater queue depth will increase block indexing rate.

## 4. Query The Service

By default, connect to:

```text
ws://localhost:8172
```

See the WebSocket API section for query specification.

## 5. Live reload

Acuity Index uses live-reload functionality for the index spec file and the options config file. When they are changed the indexer will update without restarting.

Rejected changes do not kill the running process.
