import ALF
import MD4LeanTest.Parser

def escape (s : String) : String :=
  s.foldl
    (fun acc c =>
      acc ++
        match c with
        | '&' => "&amp;"
        | '<' => "&lt;"
        | '>' => "&gt;"
        | '"' => "&quot;"
        | '\'' => "&#39;"
        | _ => String.singleton c)
    ""

def renderAuthor (a : Author) : String :=
  let label := a.realname.getD a.handle
  match a.github with
  | some gh => s!"<a href=\"https://github.com/{gh}\" target=\"_blank\" rel=\"noopener\">{(escape label)}</a>"
  | none => (escape label)

def renderDescription (description : Option String) : String :=
  match description with
  | none => ""
  | some d =>
  let content := d.trimAscii.toString
  if content.isEmpty then "" else MD4Lean.renderHtml content |>.get!

structure AppendixLink where
  label : String
  url : String

def renderCard
  (slug : String)
  (title : String)
  (authors : List Author)
  (tp : List TheoremProver)
  (tags : List Tag)
  (description : Option String := none)
  (links : List AppendixLink)
  : String :=
  s!"
    <article class=\"card\" id=\"{slug}\">
      <header class=\"card-header\">
        <div class=\"card-title-row\">
          <h2 class=\"card-title\" title=\"{title}\">
            <a href=\"#{slug}\">{title}</a>
          </h2>
          <div>
            {String.intercalate "\n" $ tp.map $ λ t => s!"<span class=\"lang-badge {t.slug}\">{t.name}</span>"}
          </div>
        </div>
        <p class=\"card-authors\">
          {String.intercalate ", " $ authors.map renderAuthor}
        </p>
        <div class=\"card-tags\">
          {String.intercalate "\n" $ tags.map $ λ t => s!"<span class=\"tag {t.slug}\">{t.name}</span>"}
        </div>
      </header>
      <div class=\"card-body\">
        {renderDescription description}
      </div>
      <footer class=\"card-footer\">
        {
          String.intercalate "\n" $ links.map $ λ l => s!"<a class=\"appendix-link\" href=\"{l.url}\" target=\"_blank\" rel=\"noopener\">{l.label}</a>"
        }
      </footer>
    </article>
  "

def renderRepoCard (r : Repository) : String :=
  renderCard
    (title := r.title)
    (slug := r.slug)
    (authors := r.authors)
    (tp := r.tp)
    (tags := r.tags)
    (description := r.description)
    (links := [{ label := "GitHub", url := r.url.toUrl }])

def renderPublicationCard (p : Publication) : String :=
  renderCard
    (title := p.title)
    (slug := p.slug)
    (authors := p.authors)
    (tp := p.tp)
    (tags := p.tags)
    (description := p.abstract)
    (links := [])

def main : IO Unit := do
  let outFile := "output/index.html"
  IO.FS.writeFile outFile $ s!"
    <!DOCTYPE html>
    <html lang=\"en\">
    <head>
      <meta charset=\"UTF-8\">
      <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">
      <meta name=\"description\" content=\"Bibliography of formalization/mechanization mainly related to mathematical logic.\" />
      <meta property=\"og:type\" content=\"website\" />
      <meta property=\"og:title\" content=\"Awesome Logic Formalization\" />
      <meta property=\"og:description\" content=\"Bibliography of formalization/mechanization mainly related to mathematical logic.\" />
      <meta property=\"og:url\" content=\"https://formalizedformallogic.github.io/awesome-logic-formalization\" />
      <meta property=\"og:image\" content=\"https://github.com/FormalizedFormalLogic.png\" />
      <meta name=\"twitter:card\" content=\"summary\" />
      <meta name=\"twitter:title\" content=\"Awesome Logic Formalization\" />
      <meta name=\"twitter:description\" content=\"Bibliography of formalization/mechanization mainly related to mathematical logic.\" />
      <link rel=\"stylesheet\" href=\"style.css\" />
      <title>Awesome Logic Formalization</title>
    </head>
    <body>
    <header class=\"site-header\">
      <h1>
        Awesome Logic Formalization
        <span class=\"entry-count\">{bibliography.length}</span>
      </h1>
      <p>
        Bibliography of formalization/mechanization mainly related to mathematical logic.
        If you want to add this, please submit a PR to our repository:
        <a href=\"https://github.com/FormalizedFormalLogic/awesome-logic-formalization\">
          https://github.com/FormalizedFormalLogic/awesome-logic-formalization
        </a>
      </p>
    </header>
    <main class=\"grid\">
      {
        String.intercalate "\n" $ bibliography.map $
          λ b => match b with
          | .repo r => renderRepoCard r
          | .pub  p => renderPublicationCard p
      }
    </main>
    </body>
    </html>
  "
  IO.println s!"Generated {outFile}"
