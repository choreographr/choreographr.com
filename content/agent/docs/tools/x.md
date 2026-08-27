+++
title = "X (Twitter) tools"
description = "Post, search, and look up users via the X API v2."
weight = 5
+++

The `x` group wraps the X API v2. Each tool requires X credentials in the
keystore (add them with `/add-x <service> <api_key> <api_key_secret>
<access_token> <access_token_secret> <bearer_or_->_` in `choreo-tui`).

| Tool | What it does |
|---|---|
| `x_post` | Post a tweet (`text`) |
| `x_search_recent` | Search recent tweets (`query`, `max_results`) |
| `x_user_lookup` | Look up a user by username or ID |
