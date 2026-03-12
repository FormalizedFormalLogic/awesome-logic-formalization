import { parse } from "jsr:@std/yaml";
import { join, dirname, fromFileUrl } from "jsr:@std/path";
import { ensureDir } from "jsr:@std/fs";
import { marked } from "npm:marked@14";

const __dirname = dirname(fromFileUrl(import.meta.url));

// ---------------------------------------------------------------------------
// Types
// ---------------------------------------------------------------------------

interface Author {
  name: string;
  github?: string;
}

interface Link {
  title?: string;
  url: string;
}

interface Entry {
  authors?: Author[];
  repository?: string;
  language?: string;
  description?: string;
  tags?: string[];
  link?: Link[];
}

type Data = Record<string, Entry>;

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

function esc(s: string): string {
  return s
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;")
    .replace(/'/g, "&#39;");
}

function langClass(lang: string): string {
  return "lang-" + lang.toLowerCase().replace(/\s+/g, "-");
}

// ---------------------------------------------------------------------------
// Rendering
// ---------------------------------------------------------------------------

function renderCard(key: string, entry: Entry): string {
  const repoUrl = esc(entry.repository ?? "");
  const language = esc(entry.language ?? "");
  const description = marked.parse((entry.description ?? "").trim()) as string;
  const tags = entry.tags ?? [];
  const authors = entry.authors ?? [];
  const links = entry.link ?? [];

  const authorsHtml = authors
    .map((a) => {
      const name = esc(a.name);
      return a.github
        ? `<a href="https://github.com/${esc(a.github)}" target="_blank" rel="noopener">${name}</a>`
        : name;
    })
    .join(", ");

  const tagsHtml = tags
    .map((t) => `<span class="tag">${esc(t)}</span>`)
    .join("");

  const langBadge = language
    ? `<span class="lang-badge ${langClass(entry.language!)}">${language}</span>`
    : "";

  const linksHtml = links.length
    ? `<ul class="related-links">${links
        .map(
          (l) =>
            `<li><a href="${esc(l.url)}" target="_blank" rel="noopener">${esc(l.title ?? "Link")}</a></li>`,
        )
        .join("")}</ul>`
    : "";

  const repoBtn = repoUrl
    ? `<a class="repo-btn" href="${repoUrl}" target="_blank" rel="noopener"><img src="/github.svg" width="14" height="14" alt="" aria-hidden="true"> Repository</a>`
    : "";

  return `
    <article class="card">
      <header class="card-header">
        <div class="card-title-row">
          <h2 class="card-title">${esc(key)}</h2>
          ${langBadge}
        </div>
        ${authorsHtml ? `<p class="card-authors">${authorsHtml}</p>` : ""}
        ${tagsHtml ? `<div class="card-tags">${tagsHtml}</div>` : ""}
      </header>
      <div class="card-body">
        ${description ? `<div class="card-description">${description}</div>` : ""}
        ${linksHtml}
      </div>
      ${repoBtn ? `<footer class="card-footer">${repoBtn}</footer>` : ""}
    </article>`;
}

function renderHtml(data: Data): string {
  const cards = Object.entries(data)
    .toSorted(([a], [b]) => a.localeCompare(b))
    .map(([k, v]) => renderCard(k, v))
    .join("\n");
  const count = Object.keys(data).length;

  return `<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Awesome Logic Formalization</title>
  <link rel="stylesheet" href="style.css" />
</head>
<body>
  <header class="site-header">
    <h1>Awesome Logic Formalization <span class="entry-count">${count}</span></h1>
    <p>Bibliography of formalization/mechanization mainly related to mathematical logic.</p>
  </header>
  <main class="grid">
${cards}
  </main>
</body>
</html>`;
}

// ---------------------------------------------------------------------------
// Main
// ---------------------------------------------------------------------------

const dataPath = join(__dirname, "data.yaml");
const outDir = join(__dirname, "output");

const raw = await Deno.readTextFile(dataPath);
const data = parse(raw) as Data;

await ensureDir(outDir);

const htmlPath = join(outDir, "index.html");
await Deno.writeTextFile(htmlPath, renderHtml(data));
console.log(`Generated output/index.html`);
