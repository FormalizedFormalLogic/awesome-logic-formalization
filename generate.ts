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

interface Repository {
  url: string;
}

interface Paper {
  doi?: string;
  repository?: string; // key reference within the same data file
  links: {
    title?: string;
    url: string;
  }[];
}

type Entry =
  | {
      authors: Author[];
      repository: Repository;
      language: string;
      description: string;
      tags?: string[];
      link?: Link[];
      title: string;
    }
  | {
      authors: Author[];
      paper: Paper;
      language: string;
      description: string;
      tags?: string[];
      link?: Link[];
      title: string;
    };

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

function toId(key: string): string {
  return key
    .replace(/'/g, "")
    .replace(/[^a-zA-Z0-9]+/g, "-")
    .replace(/^-|-$/g, "");
}

// ---------------------------------------------------------------------------
// Rendering
// ---------------------------------------------------------------------------

function renderCard(key: string, entry: Entry, data: Data): string {
  const language = esc(entry.language ?? "");
  const description = marked.parse((entry.description ?? "").trim()) as string;
  const title = entry.title;
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

  // Footer actions
  const footerItems: string[] = [];

  if ("repository" in entry) {
    footerItems.push(
      `<a class="repo-btn" href="${entry.repository.url}" target="_blank" rel="noopener"><img src="/github.svg" width="14" height="14" alt="" aria-hidden="true"> Repository</a>`,
    );
  }

  if ("paper" in entry) {
    if (entry.paper.links) {
      entry.paper.links.forEach((l) => {
        footerItems.push(
          `<a class="repo-btn" href="${l.url}" target="_blank" rel="noopener">${esc(l.title ?? "Link")}</a>`,
        );
      });
    }

    if (entry.paper.doi) {
      const doi = esc(entry.paper.doi);
      footerItems.push(
        `<a class="repo-btn" href="https://doi.org/${doi}" target="_blank" rel="noopener">DOI: ${doi}</a>`,
      );
    }
    if (entry.paper.repository && entry.paper.repository in data) {
      const refId = toId(entry.paper.repository);
      const refTitle = esc(entry.paper.repository);
      footerItems.push(
        `<a class="repo-btn" href="#${refId}"><img src="/github.svg" width="14" height="14" alt="" aria-hidden="true">${refTitle}</a>`,
      );
    }
  }

  const id = toId(key);

  return `
    <article class="card" id="${id}">
      <header class="card-header">
        <div class="card-title-row">
          <h2 class="card-title" title="${title}"><a href="#${id}">${title}</a></h2>
          ${langBadge}
        </div>
        ${authorsHtml ? `<p class="card-authors">${authorsHtml}</p>` : ""}
        ${tagsHtml ? `<div class="card-tags">${tagsHtml}</div>` : ""}
      </header>
      <div class="card-body">
        ${description ? `<div class="card-description">${description}</div>` : ""}
        ${linksHtml}
      </div>
      ${footerItems.length ? `<footer class="card-footer">${footerItems.join("\n        ")}</footer>` : ""}
    </article>`;
}

function renderHtml(data: Data): string {
  const cards = Object.entries(data)
    .toSorted(([a], [b]) => a.localeCompare(b))
    .map(([k, v]) => renderCard(k, v, data))
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
