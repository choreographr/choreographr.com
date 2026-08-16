#!/usr/bin/env bash
# Generate static/llms-full.txt — the full text of the site's Markdown content
# (docs, FAQ, blog, consulting, AI training) for LLM crawlers (llmstxt.org).
# Run at build time via `just build` (see justfile); Zola copies the result
# into docs/.
set -euo pipefail

cd "$(dirname "$0")/.."
OUT="static/llms-full.txt"

# Strip the TOML front matter (everything between the first and second `+++`).
strip_fm() {
  awk 'BEGIN{skip=1}
       /^\+\+\+$/{ c++; if (c==2) { skip=0; next } if (c>2) exit }
       !skip && !/^\+\+\+/' "$1"
}

# Extract `title = "..."` from the front matter.
title_of() {
  awk '/^\+\+\+/{c++; next}
       c==1 && /^title *=/ { sub(/^title *= *"/, ""); sub(/".*$/, ""); print; exit }' "$1"
}

# Extract the front-matter `weight` (for ordering docs like the sidebar).
weight_of() {
  awk '/^\+\+\+/{c++; next}
       c==1 && /^weight *=/ { gsub(/[^0-9]/, ""); print; exit }' "$1"
}

{
  cat <<'EOF'
# Choreographr — full text

> An all-purpose, extensible AI agent written in Rust. A persistent daemon owns
> your sessions; clients for terminal, desktop, Telegram and ACP editors come
> and go. LLM-generated code runs in a sandboxed RISC-V VM, and 70+ model
> providers work out of the box. Open source, Apache-2.0.
>
> This file contains the complete text of the site's Markdown content — the
> documentation, FAQ, blog post, consulting and AI training pages — for LLM
> crawlers. The short index is at /llms.txt.

EOF

  echo "# Documentation"
  echo
  # Docs ordered by front-matter weight (matches the docs sidebar).
  for f in $(for f in content/docs/*.md; do
               w="$(weight_of "$f")"
               printf "%04d %s\n" "${w:-999}" "$f"
             done | sort | awk '{print $2}'); do
    echo "## $(title_of "$f")"
    echo
    strip_fm "$f"
    echo
    echo
  done

  echo "# Blog"
  echo
  for f in content/blog/*.md; do
    case "$f" in *_index.md) continue ;; esac
    echo "## $(title_of "$f")"
    echo
    strip_fm "$f"
    echo
    echo
  done

  echo "# Consulting"
  echo
  strip_fm content/consulting.md
  echo

  echo "# AI Training — Đà Nẵng"
  echo
  strip_fm content/ai-training.md
  echo

  echo "# AI Coffee Meetups — Đà Nẵng"
  echo
  strip_fm content/ai-coffee-meetup.md
  echo
} > "$OUT"

echo "Wrote $OUT ($(wc -c < "$OUT") bytes)"
