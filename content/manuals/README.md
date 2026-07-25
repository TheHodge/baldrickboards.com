# Board manuals

Manual page content lives here as Markdown (`.md`) files so you can edit them in any external editor.

## File layout

```
content/manuals/{board_id}/{order}_{slug}.md
```

Example:

```
content/manuals/baldrick8/
  01_getting_started.md
  02_tech_specs.md
  03_web_interface.md
  04_troubleshooting.md   ← drop in a new section, no code changes needed
```

**Ordering** — the numeric prefix controls sidebar order (`01_`, `02_`, `03_`, …).

**Adding a section** — create a new numbered file in the board folder. It appears on the manual page and in the sidebar automatically.

**Removing a section** — delete the file.

## Section front matter

Optional YAML at the top of each file:

```yaml
---
title: Getting started
id: getting-started
specs_table: true
---
```

| Field | Purpose |
|-------|---------|
| `title` | Sidebar and page heading (defaults from the filename slug) |
| `id` | URL anchor, e.g. `#getting-started` (defaults: slug with `_` → `-`) |
| `specs_table` | Set `true` to show the auto-generated specs table above this section |

If you omit front matter, `02_tech_specs.md` defaults to title **Technical specifications** with the specs table enabled.

## Markdown syntax

### Lead paragraph

The first paragraph is styled as the page lead automatically.

### Headings

Use `###` for major steps (these appear in the sidebar table of contents). Add a custom anchor with `{#id}`:

```markdown
### Step 1: Plugging in Your Controller {#step-1-plugging-in-your-controller}
```

`####` and `#####` are supported for sub-headings.

### Callouts

```markdown
::: warn Safety First
Always disconnect power before wiring.
:::

::: note Tip
Helpful extra detail goes here.
:::

::: tip Pro tip
Same styling as a note callout.
:::
```

### Figures

Wrap board photos and optional captions:

```markdown
::: figure
![Alt text](baldrick8/board-power.png)

- Port 1 will power pixel ports 1 - 4
- Port 2 will power pixel ports 5 - 8
:::
```

Image paths are relative to `app/assets/images/`.

### Links and emphasis

Standard Markdown links become external links with site styling:

```markdown
We recommend [Meanwell Power Supplies](https://example.com).
```

Use `**bold**` and *italic* as usual.

### Complex layouts

For tabs, spec grids, or other interactive blocks you can embed raw HTML directly in the Markdown file — it passes through unchanged.

## Downloads

Each board manual page offers:

| Format | URL | Audience |
| --- | --- | --- |
| PDF | `/en/boards/{board_id}/manual.pdf` | Print / offline reading (Grover + Chromium) |
| Markdown | `/en/boards/{board_id}/manual.md` | LLMs and editors (concatenated source files + specs table) |

`public/llms.txt` points crawlers and agents at the Markdown manuals.

