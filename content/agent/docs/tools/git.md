+++
title = "Git tools"
description = "Local Git operations: status, diff, log, add, commit, push, and show."
weight = 2
+++

`git` is active by default. All git tools operate on the repository containing
the given path (defaulting to the working directory). They are implemented
with `gix` and require no shell.

| Tool | What it does |
|---|---|
| `git_status` | Show the status of the repository containing the given path |
| `git_diff` | Show the line-by-line unified diff for a file or repository |
| `git_log` | Show recent commits (`limit`) |
| `git_add` | Stage a file or pathspec |
| `git_commit` | Create a commit from the current index (`message`, `allow_empty`) |
| `git_push` | Push to a remote branch (`remote`, `branch`, `set_upstream`, `dry_run`, `force_with_lease`) |
| `git_show` | Show a Git object (commit, tree, blob, tag) or a file at a revision |

```json
{ "name": "git_diff", "arguments": { "pathspec": ["src/main.rs"] } }
{ "name": "git_commit", "arguments": { "message": "Fix off-by-one in the parser" } }
{ "name": "git_push", "arguments": { "remote": "origin", "branch": "main", "set_upstream": true } }
```
