+++
title = "Accounts & providers"
description = "Configuring model accounts, API keys, and the 200+ provider catalog."
weight = 4
+++

## Accounts

Accounts can be managed either in the TUI or via `~/.config/choreographr/accounts.toml`.

In the TUI, press `Alt+A` to open the **accounts** page, then `n` to add an
account (choose a provider, name it, and paste its API credential). See the
[quick start](@/agent/docs/quick-start.md) for the full walkthrough.

If you prefer to edit the file directly, accounts are configured via
`~/.config/choreographr/accounts.toml`. Account
names must be lowercase alphanumeric with hyphens or underscores
(`[a-z0-9_-]`). Each session may have its own account, set via
`/account <name>`; there is no global default account.

```toml
[[account]]
name = "main"
provider = "openai"
prompt_cache_affinity = true   # force the per-session cache-affinity body field on/off

[[account]]
name = "chatgpt"
provider = "chatgpt"          # OAuth provider: create it, then `/login chatgpt`

[[account]]
name = "claude"
provider = "anthropic"
meter = "payg"                 # billing meter for the warm gate: payg|tokens|requests|flat|unknown
cache_warming = "streaming"    # override the global [cache_warming] mode

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

## Credentials: API keys and OAuth

Keys can be managed in the TUI — on the accounts page (`Alt+A`), select an
account and press `c` to enter its API credential.

Alternatively, add a key for the service the account uses with the slash
command:

```
/add-key openai sk-...
```

The credential travels to the daemon as a **typed value** (API key, X tokens, or
OAuth grant) over the local socket or the Noise-encrypted TCP connection — no
key material rides the add path — and the daemon encrypts it to its own binding
public key before it reaches disk. The daemon starts **locked**, so an add is
refused until you `/unlock`; `/lock` clears credentials from memory again.

### OAuth sign-in

Some providers authenticate with an account sign-in instead of an API key. When
a provider's catalog entry carries an OAuth profile, the account takes no key:
create it, then sign in.

```
/login chatgpt
```

`/login <account>` (alias `/add-oauth`) opens the provider's consent screen
through a loopback callback. On a remote or SSH host, pass `--device` for the
headless device-code flow. What gets stored is the durable **grant** — refresh
token, client registration, and identity claim — encrypted in the keystore like
any other credential; the short-lived access token lives in daemon memory only
and is refreshed and rotated for you, proactively before it expires and once on
a `401`. If the provider rejects the grant outright, the session says so and
asks you to sign in again instead of failing silently.

An account holds **one** credential, so signing in replaces an existing key for
that account — and adding a key replaces an OAuth grant.

A provider the bundled catalog does not know can be given an OAuth profile in
the [user overlay](#catalog-overlays) with a `[provider.<slug>.oauth]` table
(`issuer`, `authorize_path`, `token_path`, `scopes`, `redirect_ports`,
`code_exchange_encoding`, `refresh_encoding`, `device_code`, and an optional
public `client_id`). A partial block is warned about and skipped, leaving the
provider's API-key behaviour in place.

## Providers

Choreographr supports **200+ providers** across three wire protocols:

- **OpenAI-compatible** — OpenAI, DeepSeek, Mistral, xAI, Groq, Together AI,
  OpenRouter, Hugging Face, GitHub Models, NVIDIA NIM, Cerebras, Fireworks AI,
  Alibaba (Qwen), Moonshot AI (Kimi), Perplexity, Z.ai, Ollama, LM Studio, and
  many more.
- **Anthropic Messages** — Anthropic Claude, MiniMax, Vercel AI Gateway, Kimi
  Code, and more.
- **Google Generative AI** — Google Gemini.

The provider/model catalog is built from **[models.dev](https://models.dev)**
plus policy overlays that supply everything models.dev can't express. Adding a
new OpenAI-compatible provider needs no client code.

### Catalog overlays

The catalog is assembled in three layers, lowest precedence to highest:

1. **models.dev base** — the provider/model information. A normalized snapshot
   (`catalog.bin`) is compiled into the binary as the built-in fallback, while
   the daemon keeps a **live** copy regenerated from models.dev at runtime
   (cached on disk and re-fetched when stale; the embedded snapshot is used when
   no live copy is available). It includes the following information: context
   windows, output limits, reasoning support and levels, vision/image
   modalities, temperature, and deprecation.
2. **Built-in overlay** — [`catalog/models-overlay.toml`](https://github.com/choreographr/choreographr/blob/master/choreo-ai-protocols/catalog/models-overlay.toml),
   compiled into the binary and merged at load time. It carries everything
   models.dev can't express: wire-protocol selection, endpoint policy, per-model
   exceptions (e.g. Anthropic `tool_loop` passback pins, Responses-API flags),
   and the local/niche providers models.dev doesn't cover (defined wholesale
   with their full model lists).
3. **User overlay** — `~/.config/choreographr/models-overlay.toml`, optional and
   sharing the same schema, merged last so it wins. Use it to fix or extend the
   catalog without rebuilding. It is **watched live** (alongside `accounts.toml`):
   edits reload on change, deleting it falls back to the two built-in layers, and
   `/refresh-models` re-reads it too.

An overlay is a TOML file: add a `[provider.<slug>]` table for each provider you
want to change, and a `[provider.<slug>.models."<model-id>"]` sub-table for each
model. Create and edit `models-overlay.toml` freely; any key not listed below is
ignored with a warning.

#### Overlay schema

Provider scalar keys (`[provider.<slug>]`), all optional:

| Key | Type | Meaning |
|---|---|---|
| `protocol` | string | Wire protocol: `"openai"`, `"anthropic"`, or `"google"` |
| `max_tokens_field` | string | OpenAI protocol only: `"max_completion_tokens"` (default) or `"max_tokens"` |
| `base_url` | string | API base URL |
| `default_model` | string | Model used when no account/session model is set |
| `display_name` | string | Human-readable name (only needed for providers not in the base) |
| `prompt_cache_short` | integer | Prompt-cache TTL of the default ephemeral tier, in seconds |
| `prompt_cache_long` | integer | Prompt-cache TTL of the extended tier, in seconds |
| `request_compression` | string | `"gzip"`, `"zstd"`, or `"identity"` (default) — compress request bodies for endpoints that decode them. Opt-in: the server must decompress, so leave it off unless support is known. A provider that rejects the encoding with `415` is downgraded to identity for the process |
| `cache_affinity` | string | `"off"` (default), `"prompt-cache-key"`, or `"openrouter-session"` — which per-session cache-affinity field this provider accepts. The daemon fills it with the turn's **real session id**, never a constant |

Per-model keys (`[provider.<slug>.models."<model-id>"]`), all optional:

| Key | Type | Meaning |
|---|---|---|
| `context_window` | integer | Context window in tokens (`0` = unknown) |
| `max_output_tokens` | integer | Output-token ceiling (`0` = unknown) |
| `reasoning_supported` | boolean | Whether the model does reasoning |
| `reasoning_levels` | array of strings | Reasoning-effort slugs (e.g. `["off", "low", "high"]`) |
| `responses` | boolean | Whether the model uses the OpenAI Responses API |
| `reasoning_passback` | string | How reasoning is echoed between turns: `"none"`, `"tool_loop"`, `"all_turns"`, `"signature"`, or `"response_id"` |
| `reasoning_echo_field` | string | The wire key replayed reasoning is shaped as (e.g. `"reasoning_content"`) |
| `reasoning_echo_required` | boolean | Whether that key must be **present** on every assistant message, empty when there is nothing to echo |
| `reasoning_content_required` | boolean | Legacy alias that sets both halves above (DeepSeek/GLM chat) |
| `supports_vision` | boolean | Whether the model accepts image input |
| `supports_image_output` | boolean | Whether the model generates images |
| `temperature` | boolean | Whether the model accepts a `temperature` parameter |
| `deprecated` | boolean | Lifecycle status |
| `prompt_cache_short` | integer | Per-model override of the default cache TTL, in seconds |
| `prompt_cache_long` | integer | Per-model override of the extended cache TTL, in seconds |
| `cache_retention` | string | `"prompt-cache-retention"` (pre-GPT-5.6 top-level `prompt_cache_retention = "24h"`) or `"prompt-cache-options"` (GPT-5.6+ nested `prompt_cache_options.ttl = "12h"`, Responses API only). **Model-level only** — the spelling depends on the model generation. Emitted only when the model also declares a long TTL tier |

#### Merge semantics

- **Provider scalars** are replaced field-by-field; any key you omit falls
  through to the lower layer.
- **Per-model entries** are keyed by `(provider, model id)`. Naming a model
  replaces only the fields you set onto the existing entry — everything you
  don't mention stays intact — and adds the entry if the model is new.
- **New providers** (a `[provider.<slug>]` table absent from the base) are
  created wholesale: give them `display_name`, `protocol`, `base_url`,
  `default_model`, and their `models`.
- **Unknown keys are warned and skipped**, never fatal, so a typo can't break
  the daemon.

#### Example user overlay

```toml
# Patch policy and catalog information for a provider that already exists.
[provider.deepseek]
max_tokens_field = "max_completion_tokens"
default_model = "deepseek-v4-pro"

[provider.deepseek.models."deepseek-v4-pro"]
context_window = 131072
reasoning_supported = true
reasoning_levels = ["off", "low", "high"]
reasoning_passback = "tool_loop"

# Define a provider models.dev doesn't list (created wholesale).
[provider.my-gateway]
display_name = "My Gateway"
protocol = "openai"
base_url = "https://gateway.example.com/v1"
default_model = "my-model"

[provider.my-gateway.models."my-model"]
context_window = 65536
supports_vision = true
```

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
| `meter` | Billing meter for prompt-cache warming: `payg`, `tokens`, `requests`, `flat`, or `unknown` |
| `cache_warming` | Per-account override of the global `[cache_warming]` mode |
| `prompt_cache_affinity` | Force the per-session cache-affinity body field on or off for this account (omitted = follow the provider catalog's capability) |

The Responses API is fully supported — including tool use, streaming, reasoning
effort slugs, multi-turn chaining via `previous_response_id`, and
**programmatic tool calling** (gpt-5.6+ models).

## Image generation and editing

Both [image tools](@/agent/docs/tools/image.md) resolve their provider from the
session's account:

- `generate_image` — OpenAI-compatible accounts use the OpenAI Images adapter
  (`gpt-image-*`), z.ai / Zhipu accounts use `glm-image`, and fal.ai accounts use
  their hosted image models (with an optional `seed`).
- `edit_image` — OpenAI Images, xAI (`grok-imagine`), and Google Gemini (which
  generates and edits through `generateContent`), plus fal.ai. z.ai / Zhipu is
  generation-only, and Anthropic has no image backend.

The model is chosen from the provider's catalog entries — image-output models
for generation, edit-capable models for editing — and can always be overridden
by passing `model` explicitly.
