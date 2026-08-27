+++
title = "Database tools"
description = "The session-scoped redb key-value store: set, get, delete, list, and count."
weight = 4
+++

The `db` group provides a persistent, session-scoped key-value store backed by
`redb`. Data survives daemon restarts. Values are arbitrary binary (`Vec<u8>`);
`db_get` returns a lossy UTF-8 conversion.

| Tool | What it does |
|---|---|
| `db_set` | Insert or overwrite a key-value pair |
| `db_get` | Retrieve a value by key |
| `db_delete` | Remove a single key |
| `db_delete_range` | Delete all keys in `[start, end)` |
| `db_get_range` | Retrieve all key-value pairs in `[start, end)` |
| `db_list` | List key names in `[start, end)` |
| `db_count` | Count keys, optionally filtered by `prefix` |

```json
{ "name": "db_set", "arguments": { "key": "todo", "value": "review PR #42" } }
{ "name": "db_get", "arguments": { "key": "todo" } }
{ "name": "db_list", "arguments": {} }
```

Use the database to remember facts, notes, and state across turns and sessions.
