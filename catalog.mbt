///|
pub(all) struct RuleSpec {
  id : String
  kind : CheckKind
  default_severity : Severity
  title : String
  evidence_hint : String
  repair_hint : String
  penalty : Int
} derive(Eq, Debug)

///|
fn rule_spec(
  id : String,
  kind : CheckKind,
  default_severity : Severity,
  title : String,
  evidence_hint : String,
  repair_hint : String,
  penalty : Int,
) -> RuleSpec {
  { id, kind, default_severity, title, evidence_hint, repair_hint, penalty }
}

///|
pub fn rule_catalog() -> Array[RuleSpec] {
  [
    rule_spec(
      "moon.mod.name",
      PackageConfig,
      Fail,
      "moon.mod declares package name",
      "name = \"<owner>/<package>\"",
      "Keep moon.mod name identical to Mooncakes owner/package.",
      12,
    ),
    rule_spec(
      "moon.mod.name-format",
      PackageConfig,
      Fail,
      "moon.mod package name is publishable",
      "URL-safe owner and package slug",
      "Use owner/package with letters, numbers, dash or underscore.",
      8,
    ),
    rule_spec(
      "moon.mod.version",
      PackageConfig,
      Fail,
      "Version is SemVer",
      "x.y.z",
      "Use a concrete release version such as 0.1.0.",
      8,
    ),
    rule_spec(
      "moon.mod.readme",
      PackageConfig,
      Warn,
      "Readme metadata uses README.md",
      "readme = \"README.md\"",
      "Point moon.mod to the root README.md file.",
      4,
    ),
    rule_spec(
      "moon.mod.repository",
      PackageConfig,
      Fail,
      "Repository URL is public and complete",
      "https://github.com/<user>/<repo>.git",
      "Set a public GitHub repository URL.",
      10,
    ),
    rule_spec(
      "moon.mod.license",
      License,
      Fail,
      "License is OSI-recognized",
      "MIT, Apache-2.0, BSD, MPL-2.0 or ISC",
      "Use an OSI-recognized SPDX license identifier.",
      10,
    ),
    rule_spec(
      "moon.mod.description",
      PackageConfig,
      Warn,
      "Description explains the package",
      "description length >= 20",
      "Write one clear sentence about the reusable capability.",
      4,
    ),
    rule_spec(
      "mooncakes.name-sync",
      Mooncakes,
      Fail,
      "Mooncakes owner/package match moon.mod",
      "snapshot owner/package equals moon.mod name",
      "Keep Mooncakes, README and moon.mod names identical.",
      10,
    ),
    rule_spec(
      "readme.exists",
      Readme,
      Fail,
      "README is present",
      "README.md content",
      "Add a complete README at repository root.",
      14,
    ),
    rule_spec(
      "readme.identity",
      Readme,
      Warn,
      "README identifies the project",
      "project or package name appears near the top",
      "Mention the project name and Mooncakes package name.",
      3,
    ),
    rule_spec(
      "readme.problem",
      Readme,
      Warn,
      "Problem statement",
      "problem, why, usage, purpose or Chinese equivalents",
      "Explain what problem the package solves.",
      3,
    ),
    rule_spec(
      "readme.install",
      Readme,
      Warn,
      "Installation",
      "moon add or install section",
      "Show the Mooncakes install command.",
      3,
    ),
    rule_spec(
      "readme.usage",
      Readme,
      Warn,
      "Minimum usage example",
      "example or moon run command",
      "Provide a copyable minimum example.",
      3,
    ),
    rule_spec(
      "readme.api",
      Readme,
      Warn,
      "Core API list",
      "API or feature list",
      "List public functions and the data model.",
      3,
    ),
    rule_spec(
      "readme.scope",
      Readme,
      Warn,
      "Supported scope",
      "supported scope",
      "State what the package supports.",
      3,
    ),
    rule_spec(
      "readme.out-of-scope",
      Readme,
      Warn,
      "Unsupported scope",
      "out of scope",
      "State what the package does not support.",
      3,
    ),
    rule_spec(
      "readme.tests",
      Readme,
      Warn,
      "Verification commands",
      "moon check, moon build, moon test",
      "Document all local verification commands.",
      3,
    ),
    rule_spec(
      "readme.license",
      Readme,
      Warn,
      "License and third-party notes",
      "license and third-party notes",
      "Explain license and third-party code or asset usage.",
      3,
    ),
    rule_spec(
      "doc.snippets",
      DocProof,
      Fail,
      "README or docs examples are extractable",
      "fenced Markdown code block evidence",
      "Add at least one fenced MoonBit example to README or docs.",
      10,
    ),
    rule_spec(
      "doc.provenance",
      DocProof,
      Fail,
      "Source provenance and license records are clear",
      "SourceEvidence records with origin and license",
      "Record source URL, license and note for non-owned inputs.",
      10,
    ),
    rule_spec(
      "ci.exists",
      ContinuousIntegration,
      Fail,
      "GitHub Actions workflow exists",
      ".github/workflows/*.yml",
      "Add a CI workflow.",
      14,
    ),
    rule_spec(
      "ci.install",
      ContinuousIntegration,
      Fail,
      "Installs MoonBit",
      "cli.moonbitlang installer",
      "Install MoonBit in CI before running moon commands.",
      7,
    ),
    rule_spec(
      "ci.check",
      ContinuousIntegration,
      Fail,
      "Runs moon check",
      "moon check",
      "Add moon check to CI.",
      7,
    ),
    rule_spec(
      "ci.build",
      ContinuousIntegration,
      Fail,
      "Runs moon build",
      "moon build",
      "Add moon build to CI.",
      7,
    ),
    rule_spec(
      "ci.test",
      ContinuousIntegration,
      Fail,
      "Runs moon test",
      "moon test",
      "Add moon test to CI.",
      7,
    ),
    rule_spec(
      "ci.example",
      ContinuousIntegration,
      Fail,
      "Runs an example",
      "moon run examples/basic or moon run cmd/main",
      "Run at least one example in CI.",
      7,
    ),
    rule_spec(
      "tests.exists",
      Tests,
      Fail,
      "Tests are present",
      "*_test.mbt or *_wbtest.mbt evidence",
      "Add tests for core behavior.",
      14,
    ),
    rule_spec(
      "tests.coverage-shape",
      Tests,
      Warn,
      "Tests cover core paths",
      "valid, invalid, boundary and export evidence",
      "Cover normal input, invalid input, boundary input and export output.",
      6,
    ),
    rule_spec(
      "examples.exists",
      Examples,
      Fail,
      "Runnable example is present",
      "examples/basic",
      "Add a runnable example package.",
      12,
    ),
    rule_spec(
      "commands.verify",
      Build,
      Fail,
      "Verification commands include check/build/test",
      "moon check, moon build, moon test",
      "Keep verification commands documented and runnable.",
      10,
    ),
    rule_spec(
      "git.repository-public",
      GitTrace,
      Fail,
      "Repository is public",
      "public repository signal",
      "Make the GitHub repository public before final submission.",
      12,
    ),
    rule_spec(
      "git.commit-count",
      GitTrace,
      Warn,
      "Development history has at least 6 commits",
      "commit_count >= 6",
      "Keep meaningful commits for implementation, tests, docs and release prep.",
      5,
    ),
    rule_spec(
      "mooncakes.published",
      Mooncakes,
      Fail,
      "Package is published to Mooncakes",
      "published package signal",
      "Run moon login, moon publish --dry-run and moon publish.",
      14,
    ),
    rule_spec(
      "license.file",
      License,
      Fail,
      "License file is present",
      "LICENSE",
      "Add the full OSI license text.",
      10,
    ),
    rule_spec(
      "maint.changelog",
      Boundary,
      Warn,
      "Changelog or release notes exist",
      "CHANGELOG.md",
      "Add a changelog with the public release notes.",
      3,
    ),
    rule_spec(
      "maint.trace-notes",
      Boundary,
      Warn,
      "Design and issue notes are retained",
      "docs/design.md and docs/issues.md",
      "Keep design notes and issue records.",
      4,
    ),
  ]
}

///|
pub fn rules_for_kind(kind : CheckKind) -> Array[RuleSpec] {
  let out = Array::new(capacity=8)
  for spec in rule_catalog() {
    if spec.kind == kind {
      out.push(spec)
    }
  }
  out
}

///|
pub fn find_rule(id : String) -> RuleSpec? {
  for spec in rule_catalog() {
    if spec.id == id {
      return Some(spec)
    }
  }
  None
}

///|
pub fn rule_catalog_markdown() -> String {
  let out = StringBuilder()
  out.write_string("# HarborCheck Rule Catalog\n\n")
  for spec in rule_catalog() {
    out.write_string("- `" + spec.id + "` ")
    out.write_string("(" + kind_text(spec.kind) + ", ")
    out.write_string(severity_text(spec.default_severity) + "): ")
    out.write_string(spec.title + ". ")
    out.write_string("Evidence: " + spec.evidence_hint + ". ")
    out.write_string("Repair: " + spec.repair_hint + "\n")
  }
  out.to_string()
}

///|
pub fn catalog_size() -> Int {
  rule_catalog().length()
}
