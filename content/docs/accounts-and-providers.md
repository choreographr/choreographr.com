+++
title = "Accounts & providers"
description = "Configuring model accounts, API keys, and the 70+ provider catalog."
weight = 4
+++

## Accounts

Accounts can be managed either in the TUI or via `~/.config/choreographr/accounts.toml`.

In the TUI, press `Ctrl+A` to open the **accounts** page, then `n` to add an
account (choose a provider, name it, and paste its API credential). See the
[quick start](@/docs/quick-start.md) for the full walkthrough.

If you prefer to edit the file directly, accounts are configured via
`~/.config/choreographr/accounts.toml`. Account
names must be lowercase alphanumeric with hyphens or underscores
(`[a-z0-9_-]`). Each session may have its own account, set via
`/account <name>`; there is no global default account.

```toml
[[account]]
name = "main"
provider = "openai"

[[account]]
name = "claude"
provider = "anthropic"

[[account]]
name = "gemini"
provider = "google"

[[account]]
name = "local"
provider = "ollama"
base_url = "http://localhost:11434/v1"
streaming = false
retry_max_attempts = 3
```

## Providers

Choreographr supports **70+ providers** across three wire protocols:

- **OpenAI-compatible** — OpenAI, DeepSeek, Mistral, xAI, Groq, Together AI,
  OpenRouter, Hugging Face, GitHub Models, NVIDIA NIM, Cerebras, Fireworks AI,
  Alibaba (Qwen), Moonshot AI (Kimi), Perplexity, Z.ai, Ollama, LM Studio, and
  many more.
- **Anthropic Messages** — Anthropic Claude, MiniMax, Vercel AI Gateway, Kimi
  Code, and more.
- **Google Generative AI** — Google Gemini.

Each provider has its own data file under
`choreo-ai-protocols/src/catalog/<slug>.toml` with a curated model list,
context windows, reasoning levels, and the API format each model uses. Adding a
new OpenAI-compatible provider requires only a catalog TOML file — zero client
code.

### Account overrides

Every field has sensible defaults from the provider catalog and can be
overridden per-account:

| Field | Description |
|---|---|
| `base_url` | API base URL |
| `streaming` | Enable/disable streaming responses |
| `retry_max_attempts` | Max retry count on transient errors |
| `retry_initial_backoff_ms` | Initial backoff between retries (ms) |
| `retry_max_backoff_ms` | Max backoff between retries (ms) |
| `connect_timeout_secs` | TCP connect timeout |
| `request_timeout_secs` | HTTP request timeout |
| `default_request_format` | Request format: `"chat_completions"` or `"responses"` |
| `programmatic_tool_calling` | Enable programmatic tool calling (Responses API, gpt-5.6+) |
| `context_window` | Default context window for all models |

The Responses API is fully supported — including tool use, streaming, reasoning
effort slugs, multi-turn chaining via `previous_response_id`, and
**programmatic tool calling** (gpt-5.6+ models).

## Adding API keys

Keys can be managed in the TUI — on the accounts page (`Ctrl+A`), select an
account and press `c` to enter its API credential.

Alternatively, add a key for the service the account uses with the slash
command:

```
/add-key openai sk-...
```

Keys are encrypted per-credential with the daemon's public key before being
stored. The daemon starts **locked** — use `/unlock` to decrypt credentials
into memory, and `/lock` to clear them again.
