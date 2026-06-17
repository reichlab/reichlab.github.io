# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Branches

- **`source`** — content/source branch; all PRs target this branch
- **`gh-pages`** (formerly `master`) — generated static site, built and pushed by CI; do not edit directly

## Commands

```sh
# Install Ruby dependencies
bundle install

# Local development server (http://localhost:4000)
bundle exec jekyll serve

# Build static site to _site/
bundle exec jekyll build --trace

# Fetch GitHub repo metadata (writes _data/repositories.yml)
bundle exec rake collect
# With auth token to avoid API rate limits:
env GH_TOKEN='<token>' bundle exec rake collect

# Full build + HTML link validation
bundle exec rake test

# Regenerate a thematic page plugin (e.g. research or teaching)
bundle exec rake ggen[research]

# Regenerate a thematic page HTML template
bundle exec rake tpgen[research,PROJECTS]
```

## Architecture

### Data-driven pages

Three pages pull content from YAML data files via Jekyll plugins rather than inline HTML:

| Page | Data source | Plugin |
|------|-------------|--------|
| `/people` | `_data/team.yml` | `_plugins/people.rb` |
| `/publications` | `_data/publications.yml` | `_plugins/publications.rb` |
| `/research`, `/teaching` | `_research/*.md`, `_teaching/*.md` + `_data/repositories.yml` | `_plugins/research.rb`, `_plugins/teaching.rb` |

Plugins run at build time as Jekyll generators, injecting data into page variables before Liquid renders the templates.

### Thematic pages (research & teaching)

`research.html` and `teaching.html` — along with their matching `_plugins/*.rb` files — are **code-generated** using [Ribosome](https://github.com/sustrik/ribosome). The single source of truth is:

- `_scripts/theme-page.html.dna` → generates `research.html` / `teaching.html`
- `_scripts/theme-gen-gen.rb.dna` → generates `_plugins/research.rb` / `_plugins/teaching.rb`

**Do not hand-edit `research.html`, `teaching.html`, `_plugins/research.rb`, or `_plugins/teaching.rb` directly.** Edit the `.dna` templates and regenerate with `rake ggen` / `rake tpgen`.

### GitHub repository metadata

Research and teaching sections can list GitHub repos (`user/repo` identifiers) in their front matter. `_scripts/collect-repos.rb` queries the GitHub API and writes metadata (last commit, language, etc.) to `_data/repositories.yml`. This file is auto-generated — do not commit manual edits to it.

### Adding content

- **Team member:** add entry to `_data/team.yml`
- **Publication:** add entry to `_data/publications.yml`; optionally add PDF at `pdfs/publications/<slug>.pdf` and image at `images/publications/<slug>.png`
- **Research/teaching section:** add a Markdown file to `_research/` or `_teaching/` with YAML front matter (`title`, `image`, `projects`, `publications` keys)
- **Blog post:** add Markdown to `blog/_posts/` with filename `YYYY-MM-DD-title.md`
