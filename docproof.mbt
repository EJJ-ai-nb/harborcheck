///|
pub(all) enum SourceKind {
  OwnedCode
  ThirdPartyCode
  Dataset
  Asset
  GeneratedText
} derive(Eq, Debug)

///|
pub(all) struct DocSnippet {
  index : Int
  language : String
  body : String
  runnable : Bool
  label : String
} derive(Eq, Debug)

///|
pub(all) struct SourceEvidence {
  name : String
  kind : SourceKind
  source_url : String
  license : String
  note : String
} derive(Eq, Debug)

///|
pub fn SourceEvidence::SourceEvidence(
  name? : String = "",
  kind? : SourceKind = OwnedCode,
  source_url? : String = "",
  license? : String = "",
  note? : String = "",
) -> SourceEvidence {
  { name, kind, source_url, license, note }
}

///|
pub(all) struct DocProofReport {
  snippet_count : Int
  runnable_snippet_count : Int
  source_count : Int
  unclear_source_count : Int
  license_issue_count : Int
  verdict : String
  snippets : Array[DocSnippet]
  sources : Array[SourceEvidence]
} derive(Eq, Debug)

///|
fn source_kind_text(kind : SourceKind) -> String {
  match kind {
    OwnedCode => "owned-code"
    ThirdPartyCode => "third-party-code"
    Dataset => "dataset"
    Asset => "asset"
    GeneratedText => "generated-text"
  }
}

///|
fn fence_language(line : String) -> String {
  let trimmed = line.trim().to_owned()
  if trimmed.length() <= 3 || !trimmed.has_prefix("```") {
    ""
  } else {
    trimmed[3:trimmed.length()].trim().to_owned()
  }
}

///|
fn snippet_is_runnable(language : String, body : String) -> Bool {
  let lang = lower(language)
  let code = lower(body)
  (lang == "moonbit" || lang == "mbt" || lang.contains("moonbit")) &&
  (
    code.contains("fn main") ||
    code.contains("test {") ||
    code.contains("inspect(") ||
    code.contains("moon run")
  )
}

///|
pub fn extract_doc_snippets(markdown : String) -> Array[DocSnippet] {
  let snippets = Array::new()
  let mut in_fence = false
  let mut language = ""
  let mut body = StringBuilder()
  let mut index = 0
  for raw in normalized(markdown).split("\n") {
    let line = raw.to_owned()
    if line.trim().has_prefix("```") {
      if in_fence {
        let text = body.to_string()
        index += 1
        snippets.push({
          index,
          language,
          body: text,
          runnable: snippet_is_runnable(language, text),
          label: "snippet-" + index.to_string(),
        })
        in_fence = false
        language = ""
        body = StringBuilder()
      } else {
        in_fence = true
        language = fence_language(line)
        body = StringBuilder()
      }
    } else if in_fence {
      body.write_string(line)
      body.write_string("\n")
    }
  }
  snippets
}

///|
fn source_has_clear_origin(source : SourceEvidence) -> Bool {
  match source.kind {
    OwnedCode => has_text(source.note) || has_text(source.name)
    _ => has_text(source.source_url) && has_text(source.name)
  }
}

///|
fn source_has_clear_license(source : SourceEvidence) -> Bool {
  match source.kind {
    OwnedCode => source.license == "MIT" || known_osi_license(source.license)
    _ =>
      known_osi_license(source.license) ||
      source.license == "CC0-1.0" ||
      source.license == "CC-BY-4.0" ||
      source.license == "Public-Domain"
  }
}

///|
pub fn doc_proof(
  markdown : String,
  sources : Array[SourceEvidence],
) -> DocProofReport {
  let snippets = extract_doc_snippets(markdown)
  let mut runnable = 0
  for snippet in snippets {
    if snippet.runnable {
      runnable += 1
    }
  }
  let mut unclear = 0
  let mut license_issues = 0
  for source in sources {
    if !source_has_clear_origin(source) {
      unclear += 1
    }
    if !source_has_clear_license(source) {
      license_issues += 1
    }
  }
  let verdict = if snippets.length() == 0 {
    "needs-examples"
  } else if runnable == 0 {
    "needs-runnable-example"
  } else if unclear > 0 || license_issues > 0 {
    "needs-source-proof"
  } else {
    "ready"
  }
  {
    snippet_count: snippets.length(),
    runnable_snippet_count: runnable,
    source_count: sources.length(),
    unclear_source_count: unclear,
    license_issue_count: license_issues,
    verdict,
    snippets,
    sources,
  }
}

///|
pub fn DocProofReport::to_markdown(self : DocProofReport) -> String {
  let out = StringBuilder()
  out.write_string("# HarborCheck Doc Proof\n\n")
  out.write_string("- Verdict: " + self.verdict + "\n")
  out.write_string("- Snippets: " + self.snippet_count.to_string() + "\n")
  out.write_string(
    "- Runnable snippets: " + self.runnable_snippet_count.to_string() + "\n",
  )
  out.write_string("- Source records: " + self.source_count.to_string() + "\n")
  out.write_string(
    "- Unclear sources: " + self.unclear_source_count.to_string() + "\n",
  )
  out.write_string(
    "- License issues: " + self.license_issue_count.to_string() + "\n\n",
  )
  out.write_string("## Snippets\n\n")
  for snippet in self.snippets {
    out.write_string("- " + snippet.label)
    out.write_string(" language=" + snippet.language)
    out.write_string(" runnable=" + snippet.runnable.to_string() + "\n")
  }
  out.write_string("\n## Source Evidence\n\n")
  if self.sources.length() == 0 {
    out.write_string("- No external source records declared.\n")
  } else {
    for source in self.sources {
      out.write_string("- " + source.name)
      out.write_string(" kind=" + source_kind_text(source.kind))
      out.write_string(" license=" + source.license + "\n")
    }
  }
  out.to_string()
}

///|
pub fn doc_proof_markdown(
  markdown : String,
  sources : Array[SourceEvidence],
) -> String {
  doc_proof(markdown, sources).to_markdown()
}
