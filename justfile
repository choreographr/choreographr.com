set shell := ["bash", "-cu"]

default:
    just --list

# Install frontend tooling
install:
    pnpm install

# Build Tailwind and minify into static/css/main.css
css-build:
    pnpm run build:css

# Watch Tailwind styles during development
css-watch:
    pnpm run dev:css

# Build the site into docs/
build: css-build
    zola build -u "https://choreographr.com/"

# Build drafts, future, and expired content too
build-all: css-build
    zola build --drafts -u "https://choreographr.com/"

# Serve locally with live reload (run `just css-watch` in another terminal)
#
# Serve into `public/` (gitignored) instead of the committed `docs/` deploy
# dir: `zola serve` wipes its output directory on Ctrl+C, which would
# delete the GitHub Pages source if pointed at docs/.
serve:
    zola serve -u "/" -o public --force

# Serve including drafts, future, and expired content
serve-all:
    zola serve --drafts -u "/" -o public --force

# Check the site for errors without building
check:
    zola check

# Clean generated output
clean:
    rm -rf docs node_modules pnpm-lock.yaml

# Open the local dev server after starting it
open:
    zola serve --open -u "/" -o public --force

# Create a new page: just new content/my-page.md
new path:
    zola new {{path}}
