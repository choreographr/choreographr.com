+++
title = "Image generation & editing"
description = "generate_image and edit_image: text-to-image and image-to-image through the session's image-capable provider."
weight = 7
+++

The `image` group holds two tools: `generate_image` produces a new image from a
text prompt, and `edit_image` modifies one or more existing images from a text
prompt. Neither is active by default — activate both with `load_tools image`.

| Tool | What it does |
|---|---|
| `generate_image` | Generate an image from a text prompt; the result is displayed inline in the client exactly like `display_image` |
| `edit_image` | Edit one or more images from a text prompt (image-to-image), optionally masked |

## `generate_image` arguments

| Argument | Meaning |
|---|---|
| `prompt` | What to depict (required). Photographic results come from photographic language (lens, lighting, film, camera detail); illustration phrasing produces illustration |
| `model` | Explicit image model id (e.g. `gpt-image-1`, `glm-image`). Optional — when omitted, the provider's catalog image models are picked by priority |
| `size` | Output canvas: `auto`, `1024x1024`, `1024x1536`, or `1536x1024` |
| `quality` | Render quality hint: `auto`, `low`, `medium`, or `high` |
| `output_format` | Encoded format of the returned image: `png`, `jpeg`, or `webp` |
| `background` | `auto`, `opaque`, or `transparent` (transparent requires png/webp) |
| `alt` | Alt text for the displayed image |
| `seed` | Optional seed for reproducible generation (fal.ai only) |

```json
{
  "name": "generate_image",
  "arguments": {
    "prompt": "a lighthouse at dusk, 35mm film grain",
    "size": "1024x1024"
  }
}
```

## `edit_image`

`edit_image` takes the same prompt-and-model shape as `generate_image`, plus the
images to work on. Each input is either a local file path or a **session
reference** to an image already in the conversation:

| Reference | Meaning |
|---|---|
| `@last` | The most recent image in the session — one you just shared, or one `generate_image` / `edit_image` produced |
| `@display:<turn>:<index>` | A specific displayed image, by turn and index within it |
| `@result:<turn>:<call_id>` | A specific tool result's image, by turn and tool-call id |

| Argument | Meaning |
|---|---|
| `prompt` | What to change (required). Describe the edit, not the whole image |
| `images` | One or more inputs: local paths or the session references above (required, at least one) |
| `mask` | Optional PNG path whose **transparent** region is the area regenerated; the opaque region is preserved (only on models that can inpaint) |
| `model` | Explicit edit-capable model id. Optional — when omitted, the provider's catalog edit models are picked by priority |
| `size`, `quality`, `output_format`, `background`, `alt` | The same output knobs as `generate_image` |

```json
{ "name": "edit_image", "arguments": {
    "prompt": "replace the sky with a sunset",
    "images": ["@last"] } }
```

Because `@last` resolves against the session, a refinement loop needs no file
management at all: generate, look at the result, then edit it in place.

## Providers & model selection

Both tools run against the session's account.

- **`generate_image`** — OpenAI Images (`gpt-image-*`), z.ai / Zhipu GLM
  (`glm-image`), and fal.ai (flux and other hosted models, accepting `seed`).
- **`edit_image`** — OpenAI Images, xAI (`grok-imagine`: OpenAI-protocol
  generation, but a JSON body on `/images/edits` for editing), Google Gemini
  (generation and editing through `generateContent`, inputs sent as `inlineData`
  parts), and fal.ai. z.ai / Zhipu is generation-only, and Anthropic has no
  image backend.

Model selection is catalog-driven: an explicit `model` argument always wins;
otherwise the provider's verified image-output models are picked by priority for
generation (`gpt-image` > `imagen` > `gemini-image` > `flux` > `dall-e`), and its
verified edit-capable models for editing. There is no guessed fallback: if the
provider has no suitable models in the catalog, the tool fails with guidance to
pass `model` explicitly, or to add an overlay entry and run `/refresh-models`.
Edit capability is overlay-only policy, and `edit_image` fails closed when the
resolved provider pins no edit-capable model.

## The result

Generated and edited bytes re-enter the same pipeline as `display_image`: the
image is shown inline in the client, persisted durably in the
`session_attachments` table, and can be read back with `read_image` — so the
model sees its own output and can refine it. Both tools also report the model
that produced the image and, when the provider returns one, the provider's
revised prompt.

> The credential never reaches the tool: provider resolution runs through the
> daemon command loop, scoped to the requesting session, so cancelling the
> session also aborts an in-flight generation or edit.
