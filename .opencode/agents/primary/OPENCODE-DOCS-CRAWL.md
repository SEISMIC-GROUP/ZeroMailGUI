### Crawl and index OpenCode Docs with Bright Data MCP

- **Target site**: [OpenCode Docs](https://opencode.ai/docs/)
- **Output directory (absolute path)**: `/Users/charliefisher/Desktop/SEISMIC-CURSOR/more/TASKMANGER 6 (PLAYGROUND)/.opencode/opencode docs`
- **Scope**: Only URLs under `https://opencode.ai/docs/` (same origin, path prefix `/docs/`)
- **Goal**: Fetch every docs page, convert to Markdown, write files mirroring site structure, and generate a searchable `index.json`.

---

### Tools
- **Bright Data MCP: scrape_as_markdown** — use to retrieve each page’s content as Markdown.
- (Optional) **Bright Data MCP: search_engine** — use if you need to discover URLs beyond the docs index page.

---

### Requirements
1. **Discover all docs URLs**
   - Start from `https://opencode.ai/docs/`.
   - Crawl breadth-first, following links that:
     - Are same-origin (`opencode.ai`), and
     - Have path starting with `/docs/`.
   - Include both with/without trailing slash; de-duplicate normalized URLs.
   - Exclude external links, mailto, fragments (`#...`), and non-HTTP(S).
2. **Fetch and convert**
   - For each discovered docs URL, call Bright Data MCP `scrape_as_markdown` to get Markdown content.
   - If fetch fails, retry with exponential backoff up to 3 times; log failures.
   - Respect polite crawling: ≤ 4 concurrent requests, 300–600ms jittered delay between requests.
3. **Persist Markdown files**
   - Create the output directory if missing: `/Users/charliefisher/Desktop/SEISMIC-CURSOR/more/TASKMANGER 6 (PLAYGROUND)/.opencode/opencode docs`.
   - Mirror URL path structure under the output directory.
     - Example: `https://opencode.ai/docs/usage/cli/` → `.../.opencode/opencode docs/docs/usage/cli/index.md`
     - If a URL ends with a filename (no trailing slash), write `.../path/to/page.md`. Otherwise use `index.md`.
   - Sanitize filenames safely (lowercase, hyphenate spaces, remove query params).
4. **Index**
   - Generate `index.json` at the output root.
   - For each page entry include:
     - `url`: canonical source URL
     - `relativePath`: path under the output directory
     - `title`: first Markdown level-1 heading if present, otherwise derive from URL
     - `headings`: array of `{ level, text }` for headings h1–h3 parsed from Markdown
     - `updatedAt`: ISO timestamp when fetched
     - `hash`: content hash (e.g., SHA-256 of Markdown)
   - If `index.json` exists, update incrementally and skip re-writing files whose `hash` is unchanged (idempotent sync).
5. **Logging**
   - Print a concise crawl summary: total discovered, fetched, skipped (unchanged), failed.
   - Emit a `README.md` in the output directory describing the dataset, run timestamp, and how to re-run.

---

### Implementation Notes
- Normalize URLs: lower-case host, remove hash fragments, keep query only if within scope and meaningful.
- Handle redirects; store the final resolved URL as canonical.
- Convert relative links inside Markdown to their mirrored relative paths when possible.
- Ensure the crawl completes across all paginated or nested sections under `/docs/`.

---

### Pseudocode Outline

```text
initialize queue with https://opencode.ai/docs/
initialize visited set
initialize results list

while queue not empty:
  url = queue.pop()
  if url in visited: continue
  visited.add(url)

  md = brightdata.scrape_as_markdown(url)
  if md fetch failed (after retries): record failure; continue

  discovered = parse_links_from_markdown(md)  // same-origin, path starts with /docs/
  enqueue all new discovered URLs not in visited

  outPath = mapUrlToLocalPath(url)            // mirror structure under output dir
  write md to outPath                         // create dirs as needed

  meta = extract_meta(md)                     // title, headings
  hash = sha256(md)
  update index.json (url, relativePath, title, headings, updatedAt, hash)

write README.md and crawl summary
```

---

### Acceptance Criteria
- Every reachable page under `https://opencode.ai/docs/` is saved as Markdown under the output directory, mirroring structure.
- `index.json` exists with a record for each page including `url`, `relativePath`, `title`, `headings`, `updatedAt`, and `hash`.
- Re-running performs an incremental sync and skips unchanged pages.
- Crawl summary is printed and failures (if any) are listed.

---

### Start
- Begin at: `https://opencode.ai/docs/`
- Output root: `/Users/charliefisher/Desktop/SEISMIC-CURSOR/more/TASKMANGER 6 (PLAYGROUND)/.opencode/opencode docs`

Proceed using the Bright Data MCP tools as specified.
