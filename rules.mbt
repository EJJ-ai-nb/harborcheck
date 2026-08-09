///|
fn push_manifest_findings(
  findings : Array[Finding],
  snapshot : ProjectSnapshot,
  manifest : PackageManifest,
) -> Unit {
  if manifest.module_name.is_empty() {
    findings.push(
      fail(
        "moon.mod.name",
        PackageConfig,
        "moon.mod declares package name",
        "The module name is missing.",
        "Set name = \"<owner>/<package>\" before publishing.",
        "name",
        penalty=12,
      ),
    )
  } else if !manifest.has_valid_name {
    findings.push(
      fail(
        "moon.mod.name-format",
        PackageConfig,
        "moon.mod package name is publishable",
        "The package name should be owner/package and use URL-safe characters.",
        "Use the same owner and package name in moon.mod and Mooncakes.",
        manifest.module_name,
        penalty=8,
      ),
    )
  } else {
    findings.push(
      pass(
        "moon.mod.name",
        PackageConfig,
        "moon.mod package name is present",
        manifest.module_name,
      ),
    )
  }
  if manifest.has_semver {
    findings.push(
      pass(
        "moon.mod.version",
        PackageConfig,
        "Version is SemVer",
        manifest.version,
      ),
    )
  } else {
    findings.push(
      fail(
        "moon.mod.version",
        PackageConfig,
        "Version is SemVer",
        "Mooncakes releases should use a concrete x.y.z version.",
        "Use version = \"0.1.0\" for the first public release.",
        manifest.version,
        penalty=8,
      ),
    )
  }
  if manifest.readme == "README.md" {
    findings.push(
      pass(
        "moon.mod.readme",
        PackageConfig,
        "Readme points to README.md",
        manifest.readme,
      ),
    )
  } else {
    findings.push(
      warn(
        "moon.mod.readme",
        PackageConfig,
        "Readme metadata uses README.md",
        "Reviewers expect a normal README.md file at the repository root.",
        "Set readme = \"README.md\".",
        manifest.readme,
        penalty=4,
      ),
    )
  }
  if manifest.repository.has_prefix("https://github.com/") &&
    manifest.repository.has_suffix(".git") {
    findings.push(
      pass(
        "moon.mod.repository",
        PackageConfig,
        "Repository URL is a GitHub git URL",
        manifest.repository,
      ),
    )
  } else {
    findings.push(
      fail(
        "moon.mod.repository",
        PackageConfig,
        "Repository URL is public and complete",
        "The repository metadata is empty or not a GitHub git URL.",
        "Set repository = \"https://github.com/<user>/<repo>.git\".",
        manifest.repository,
        penalty=10,
      ),
    )
  }
  if known_osi_license(manifest.license) {
    findings.push(
      pass(
        "moon.mod.license",
        License,
        "License is OSI-recognized",
        manifest.license,
      ),
    )
  } else {
    findings.push(
      fail(
        "moon.mod.license",
        License,
        "License is OSI-recognized",
        "The package license is missing or not in the built-in SPDX allow list.",
        "Use MIT or Apache-2.0 unless your project has a stronger reason.",
        manifest.license,
        penalty=10,
      ),
    )
  }
  if manifest.description.length() >= 20 {
    findings.push(
      pass(
        "moon.mod.description",
        PackageConfig,
        "Description explains the package",
        manifest.description,
      ),
    )
  } else {
    findings.push(
      warn(
        "moon.mod.description",
        PackageConfig,
        "Description explains the package",
        "A very short description makes the Mooncakes package harder to evaluate.",
        "Write one clear sentence about the reusable capability.",
        manifest.description,
        penalty=4,
      ),
    )
  }
  if snapshot.mooncakes_owner == "" ||
    snapshot.mooncakes_package == "" ||
    (
      snapshot.mooncakes_owner == manifest.owner &&
      snapshot.mooncakes_package == manifest.package_name
    ) {
    findings.push(
      pass(
        "mooncakes.name-sync",
        Mooncakes,
        "Mooncakes owner/package match moon.mod",
        manifest.module_name,
      ),
    )
  } else {
    findings.push(
      fail(
        "mooncakes.name-sync",
        Mooncakes,
        "Mooncakes owner/package match moon.mod",
        "Snapshot metadata does not match moon.mod.",
        "Keep Mooncakes, README and moon.mod names identical.",
        snapshot.mooncakes_owner + "/" + snapshot.mooncakes_package,
        penalty=10,
      ),
    )
  }
}

///|
fn push_readme_findings(
  findings : Array[Finding],
  snapshot : ProjectSnapshot,
  manifest : PackageManifest,
) -> Unit {
  let readme = snapshot.readme
  if !has_text(readme) {
    findings.push(
      fail(
        "readme.exists",
        Readme,
        "README is present",
        "README content is empty.",
        "Add a complete README with goal, installation, usage, API, tests and license.",
        "README.md",
        penalty=14,
      ),
    )
    return
  }
  findings.push(pass("readme.exists", Readme, "README is present", "README.md"))
  if contains_ci(readme, snapshot.name) ||
    contains_ci(readme, manifest.package_name) {
    findings.push(
      pass(
        "readme.identity",
        Readme,
        "README identifies the project",
        snapshot.name,
      ),
    )
  } else {
    findings.push(
      warn(
        "readme.identity",
        Readme,
        "README identifies the project",
        "The README does not clearly name the project.",
        "Mention the package name near the top.",
        snapshot.name,
        penalty=3,
      ),
    )
  }
  let required = [
    (
      "readme.problem",
      "Problem statement",
      ["解决", "problem", "why", "用途"],
    ),
    ("readme.install", "Installation", ["安装", "moon add", "install"]),
    (
      "readme.usage",
      "Minimum usage example",
      ["使用", "example", "moon run", "示例"],
    ),
    ("readme.api", "Core API list", ["api", "核心功能", "功能列表"]),
    ("readme.scope", "Supported scope", ["支持范围", "scope"]),
    (
      "readme.out-of-scope",
      "Unsupported scope",
      ["暂不支持", "out of scope"],
    ),
    (
      "readme.tests",
      "Verification commands",
      ["moon check", "moon build", "moon test"],
    ),
    (
      "readme.license",
      "License and third-party notes",
      ["license", "许可证", "third-party", "第三方"],
    ),
  ]
  for item in required {
    let (id, title, needles) = item
    if contains_any(readme, needles) {
      findings.push(pass(id, Readme, title, needles[0]))
    } else {
      findings.push(
        warn(
          id,
          Readme,
          title,
          "A required README section or keyword was not found.",
          "Add a short section that covers this requirement.",
          title,
          penalty=3,
        ),
      )
    }
  }
}

///|
fn push_ci_findings(
  findings : Array[Finding],
  snapshot : ProjectSnapshot,
) -> Unit {
  let ci = snapshot.ci_workflow
  if !has_text(ci) {
    findings.push(
      fail(
        "ci.exists",
        ContinuousIntegration,
        "GitHub Actions workflow exists",
        "No CI workflow content was provided.",
        "Add .github/workflows/ci.yml with MoonBit install, check, build, test and smoke run.",
        ".github/workflows/ci.yml",
        penalty=14,
      ),
    )
    return
  }
  findings.push(
    pass(
      "ci.exists",
      ContinuousIntegration,
      "GitHub Actions workflow exists",
      ".github/workflows/ci.yml",
    ),
  )
  let commands = [
    ("ci.install", "Installs MoonBit", ["cli.moonbitlang", "moonbit"]),
    ("ci.check", "Runs moon check", ["moon check"]),
    ("ci.build", "Runs moon build", ["moon build"]),
    ("ci.test", "Runs moon test", ["moon test"]),
    (
      "ci.example",
      "Runs an example",
      ["moon run examples", "moon run cmd/main"],
    ),
  ]
  for item in commands {
    let (id, title, needles) = item
    if contains_any(ci, needles) {
      findings.push(pass(id, ContinuousIntegration, title, needles[0]))
    } else {
      findings.push(
        fail(
          id,
          ContinuousIntegration,
          title,
          "The workflow does not show this verification command.",
          "Add the missing CI step so reviewers can reproduce validation.",
          title,
          penalty=7,
        ),
      )
    }
  }
}

///|
fn push_test_and_example_findings(
  findings : Array[Finding],
  snapshot : ProjectSnapshot,
) -> Unit {
  if snapshot.tests.length() == 0 {
    findings.push(
      fail(
        "tests.exists",
        Tests,
        "Tests are present",
        "No test fixtures were provided.",
        "Add tests for valid input, invalid input, boundaries, transformations and exports.",
        "tests",
        penalty=14,
      ),
    )
  } else {
    findings.push(
      pass(
        "tests.exists",
        Tests,
        "Tests are present",
        snapshot.tests.length().to_string(),
      ),
    )
  }
  let normal = count_contains(snapshot.tests, "valid") +
    count_contains(snapshot.tests, "pass")
  let invalid = count_contains(snapshot.tests, "invalid") +
    count_contains(snapshot.tests, "fail")
  let boundary = count_contains(snapshot.tests, "boundary") +
    count_contains(snapshot.tests, "empty")
  let export_count = count_contains(snapshot.tests, "markdown") +
    count_contains(snapshot.tests, "json")
  if normal > 0 && invalid > 0 && boundary > 0 && export_count > 0 {
    findings.push(
      pass(
        "tests.coverage-shape",
        Tests,
        "Tests cover core paths",
        "valid/invalid/boundary/export",
      ),
    )
  } else {
    findings.push(
      warn(
        "tests.coverage-shape",
        Tests,
        "Tests cover core paths",
        "The test descriptions do not show all required path types.",
        "Cover normal input, invalid input, boundary input, data conversion and export output.",
        "normal=\{normal}, invalid=\{invalid}, boundary=\{boundary}, export=\{export_count}",
        penalty=6,
      ),
    )
  }
  if snapshot.examples.length() > 0 {
    findings.push(
      pass(
        "examples.exists",
        Examples,
        "Runnable example is present",
        snapshot.examples.length().to_string(),
      ),
    )
  } else {
    findings.push(
      fail(
        "examples.exists",
        Examples,
        "Runnable example is present",
        "No runnable example was declared.",
        "Add examples/basic with moon.pkg and main.mbt.",
        "examples",
        penalty=12,
      ),
    )
  }
  if contains_any(snapshot.commands.join("\n"), ["moon check"]) &&
    contains_any(snapshot.commands.join("\n"), ["moon build"]) &&
    contains_any(snapshot.commands.join("\n"), ["moon test"]) {
    findings.push(
      pass(
        "commands.verify",
        Build,
        "Verification commands include check/build/test",
        "moon check/build/test",
      ),
    )
  } else {
    findings.push(
      fail(
        "commands.verify",
        Build,
        "Verification commands include check/build/test",
        "The verification command list is incomplete.",
        "Document and run moon check, moon build and moon test.",
        snapshot.commands.join(", "),
        penalty=10,
      ),
    )
  }
}

///|
fn push_release_findings(
  findings : Array[Finding],
  snapshot : ProjectSnapshot,
) -> Unit {
  if snapshot.repository_public {
    findings.push(
      pass(
        "git.repository-public",
        GitTrace,
        "Repository is public",
        "public=true",
      ),
    )
  } else {
    findings.push(
      fail(
        "git.repository-public",
        GitTrace,
        "Repository is public",
        "The project snapshot says the repository is not public.",
        "Publish the GitHub repository before final submission.",
        "public=false",
        penalty=12,
      ),
    )
  }
  if snapshot.commit_count >= 6 {
    findings.push(
      pass(
        "git.commit-count",
        GitTrace,
        "Development history has at least 6 commits",
        snapshot.commit_count.to_string(),
      ),
    )
  } else {
    findings.push(
      warn(
        "git.commit-count",
        GitTrace,
        "Development history has at least 6 commits",
        "The commit count is below the suggested threshold.",
        "Keep meaningful commits for model, rules, tests, docs, CI and release prep.",
        snapshot.commit_count.to_string(),
        penalty=5,
      ),
    )
  }
  if snapshot.mooncakes_published {
    findings.push(
      pass(
        "mooncakes.published",
        Mooncakes,
        "Package is published to Mooncakes",
        "published=true",
      ),
    )
  } else {
    findings.push(
      fail(
        "mooncakes.published",
        Mooncakes,
        "Package is published to Mooncakes",
        "The snapshot marks Mooncakes publication as incomplete.",
        "Run moon login, moon publish --dry-run and moon publish after GitHub is public.",
        "published=false",
        penalty=14,
      ),
    )
  }
  if has_text(snapshot.license_text) &&
    contains_any(snapshot.license_text, ["MIT License", "Apache License"]) {
    findings.push(
      pass("license.file", License, "License file is present", "LICENSE"),
    )
  } else {
    findings.push(
      fail(
        "license.file",
        License,
        "License file is present",
        "The license file is missing or does not look like MIT/Apache text.",
        "Add the full license text at LICENSE.",
        "LICENSE",
        penalty=10,
      ),
    )
  }
  if has_text(snapshot.changelog) {
    findings.push(
      pass(
        "maint.changelog",
        Boundary,
        "Changelog or release notes exist",
        "CHANGELOG.md",
      ),
    )
  } else {
    findings.push(
      warn(
        "maint.changelog",
        Boundary,
        "Changelog or release notes exist",
        "A changelog helps reviewers see maintenance value.",
        "Add CHANGELOG.md with the 0.1.0 release notes.",
        "CHANGELOG.md",
        penalty=3,
      ),
    )
  }
  if has_text(snapshot.design_notes) && has_text(snapshot.issue_notes) {
    findings.push(
      pass(
        "maint.trace-notes",
        Boundary,
        "Design and issue notes are retained",
        "docs/",
      ),
    )
  } else {
    findings.push(
      warn(
        "maint.trace-notes",
        Boundary,
        "Design and issue notes are retained",
        "Design notes or issue records are missing.",
        "Add docs/design.md and docs/issues.md.",
        "docs",
        penalty=4,
      ),
    )
  }
}

///|
fn count_severity(findings : Array[Finding], severity : Severity) -> Int {
  let mut total = 0
  for finding in findings {
    if finding.severity == severity {
      total += 1
    }
  }
  total
}

///|
fn score_findings(findings : Array[Finding]) -> Int {
  let mut penalty = 0
  for finding in findings {
    penalty += finding.penalty
  }
  (100 - penalty).clamp(min=0, max=100)
}

///|
fn verdict_for(score : Int, fail_count : Int) -> String {
  if fail_count == 0 && score >= 90 {
    "ready"
  } else if fail_count <= 2 && score >= 75 {
    "almost-ready"
  } else {
    "needs-work"
  }
}

///|
fn run_audit(snapshot : ProjectSnapshot) -> AuditReport {
  let manifest = parse_manifest(snapshot.moon_mod)
  let findings = Array::new(capacity=48)
  push_manifest_findings(findings, snapshot, manifest)
  push_readme_findings(findings, snapshot, manifest)
  push_ci_findings(findings, snapshot)
  push_test_and_example_findings(findings, snapshot)
  push_release_findings(findings, snapshot)
  let pass_count = count_severity(findings, Pass)
  let warn_count = count_severity(findings, Warn)
  let fail_count = count_severity(findings, Fail)
  let score = score_findings(findings)
  {
    project_name: snapshot.name,
    score,
    max_score: 100,
    verdict: verdict_for(score, fail_count),
    package_name: manifest.module_name,
    repository: manifest.repository,
    findings,
    metrics: {
      pass_count,
      warn_count,
      fail_count,
      command_count: snapshot.commands.length(),
      test_fixture_count: snapshot.tests.length(),
      example_count: snapshot.examples.length(),
    },
  }
}
