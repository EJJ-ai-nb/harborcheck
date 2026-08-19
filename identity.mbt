///|
pub(all) struct SubmissionIdentity {
  applicant_name : String
  phone : String
  email : String
  github_owner : String
  repository_name : String
  mooncakes_owner : String
  package_name : String
} derive(Eq, Debug)

///|
pub fn SubmissionIdentity::SubmissionIdentity(
  applicant_name? : String = "",
  phone? : String = "",
  email? : String = "",
  github_owner? : String = "",
  repository_name? : String = "",
  mooncakes_owner? : String = "",
  package_name? : String = "",
) -> SubmissionIdentity {
  {
    applicant_name,
    phone,
    email,
    github_owner,
    repository_name,
    mooncakes_owner,
    package_name,
  }
}

///|
pub(all) struct IdentityEvidence {
  key : String
  value : String
  source : String
  note : String
} derive(Eq, Debug)

///|
pub fn IdentityEvidence::IdentityEvidence(
  key? : String = "",
  value? : String = "",
  source? : String = "",
  note? : String = "",
) -> IdentityEvidence {
  { key, value, source, note }
}

///|
pub(all) struct IdentityFinding {
  id : String
  severity : Severity
  title : String
  expected : String
  actual : String
  source : String
  detail : String
} derive(Eq, Debug)

///|
pub(all) struct IdentityReport {
  canonical : SubmissionIdentity
  evidence : Array[IdentityEvidence]
  findings : Array[IdentityFinding]
  score : Int
  verdict : String
} derive(Eq, Debug)

///|
pub fn identity_consistency(
  canonical : SubmissionIdentity,
  evidence : Array[IdentityEvidence],
) -> IdentityReport {
  let findings = Array::new(capacity=evidence.length() + 2)
  for item in evidence {
    let expected = expected_identity_value(canonical, item.key)
    if expected == "" {
      findings.push(
        identity_warn(
          "identity.unknown-key",
          "Unknown identity evidence key",
          "",
          item.value,
          item.source,
          "The evidence key is not part of the canonical identity profile.",
        ),
      )
    } else if item.value.trim().is_empty() {
      findings.push(
        identity_fail(
          item.key,
          "Identity evidence is missing",
          expected,
          item.value,
          item.source,
          "Add the expected value to the referenced submission material.",
        ),
      )
    } else if normalized_identity(item.value) == normalized_identity(expected) {
      findings.push(
        identity_pass(
          item.key,
          "Identity evidence matches",
          expected,
          item.value,
          item.source,
        ),
      )
    } else {
      findings.push(
        identity_fail(
          item.key,
          "Identity evidence does not match",
          expected,
          item.value,
          item.source,
          "Use one applicant identity across the submission, repository URL, git author and Mooncakes package.",
        ),
      )
    }
  }
  let score = identity_score(findings)
  { canonical, evidence, findings, score, verdict: identity_verdict(findings) }
}

///|
pub fn acceptance_identity_report(
  canonical : SubmissionIdentity,
  snapshot : ProjectSnapshot,
  submission_text : String,
  git_user_name? : String = "",
  git_user_email? : String = "",
  git_remote? : String = "",
) -> IdentityReport {
  let manifest = parse_manifest(snapshot.moon_mod)
  let repository = if git_remote.trim().is_empty() {
    manifest.repository
  } else {
    git_remote
  }
  let evidence = identity_evidence_from_snapshot(
    canonical, snapshot, submission_text, manifest, repository, git_user_name, git_user_email,
  )
  identity_consistency(canonical, evidence)
}

///|
pub fn identity_markdown(report : IdentityReport) -> String {
  report.to_markdown()
}

///|
pub fn identity_json(report : IdentityReport) -> String {
  report.to_json()
}

///|
pub fn IdentityReport::has_mismatch(self : IdentityReport) -> Bool {
  for finding in self.findings {
    if finding.severity == Fail {
      return true
    }
  }
  false
}

///|
pub fn IdentityReport::matching_count(self : IdentityReport) -> Int {
  let mut total = 0
  for finding in self.findings {
    if finding.severity == Pass {
      total += 1
    }
  }
  total
}

///|
pub fn IdentityReport::mismatch_count(self : IdentityReport) -> Int {
  let mut total = 0
  for finding in self.findings {
    if finding.severity == Fail {
      total += 1
    }
  }
  total
}

///|
pub fn IdentityReport::review_count(self : IdentityReport) -> Int {
  let mut total = 0
  for finding in self.findings {
    if finding.severity == Warn {
      total += 1
    }
  }
  total
}

///|
pub fn IdentityReport::to_markdown(self : IdentityReport) -> String {
  let out = StringBuilder()
  out.write_string("# HarborCheck Identity Proof\n\n")
  out.write_string("- Verdict: " + self.verdict + "\n")
  out.write_string("- Score: " + self.score.to_string() + "/100\n")
  out.write_string("- GitHub owner: " + self.canonical.github_owner + "\n")
  out.write_string(
    "- Mooncakes owner: " + self.canonical.mooncakes_owner + "\n",
  )
  out.write_string("- Package: " + self.canonical.package_name + "\n")
  out.write_string(
    "- Matching evidence: " + self.matching_count().to_string() + "\n",
  )
  out.write_string(
    "- Mismatches: " + self.mismatch_count().to_string() + "\n\n",
  )
  out.write_string("## Evidence\n\n")
  for finding in self.findings {
    out.write_string("- [" + severity_text(finding.severity) + "] ")
    out.write_string(finding.id + ": " + finding.title)
    if finding.source != "" {
      out.write_string(" -- " + finding.source)
    }
    if finding.severity != Pass {
      out.write_string(" expected=`" + finding.expected + "`")
      out.write_string(" actual=`" + finding.actual + "`")
    }
    out.write_string("\n")
  }
  out.to_string()
}

///|
pub fn IdentityReport::to_json(self : IdentityReport) -> String {
  let out = StringBuilder()
  out.write_string("{")
  out.write_string("\"verdict\":\"" + json_escape(self.verdict) + "\",")
  out.write_string("\"score\":" + self.score.to_string() + ",")
  out.write_string("\"matching\":" + self.matching_count().to_string() + ",")
  out.write_string("\"mismatches\":" + self.mismatch_count().to_string() + ",")
  out.write_string(
    "\"github_owner\":\"" + json_escape(self.canonical.github_owner) + "\",",
  )
  out.write_string(
    "\"mooncakes_owner\":\"" +
    json_escape(self.canonical.mooncakes_owner) +
    "\",",
  )
  out.write_string(
    "\"package\":\"" + json_escape(self.canonical.package_name) + "\",",
  )
  out.write_string("\"findings\":[")
  for i in 0..<self.findings.length() {
    let finding = self.findings[i]
    if i > 0 {
      out.write_string(",")
    }
    out.write_string("{")
    out.write_string("\"id\":\"" + json_escape(finding.id) + "\",")
    out.write_string(
      "\"severity\":\"" + severity_text(finding.severity) + "\",",
    )
    out.write_string("\"source\":\"" + json_escape(finding.source) + "\",")
    out.write_string("\"expected\":\"" + json_escape(finding.expected) + "\",")
    out.write_string("\"actual\":\"" + json_escape(finding.actual) + "\"")
    out.write_string("}")
  }
  out.write_string("]}")
  out.to_string()
}

///|
fn identity_evidence_from_snapshot(
  canonical : SubmissionIdentity,
  snapshot : ProjectSnapshot,
  submission_text : String,
  manifest : PackageManifest,
  repository : String,
  git_user_name : String,
  git_user_email : String,
) -> Array[IdentityEvidence] {
  [
    IdentityEvidence(
      key="applicant.name",
      value=present_value(submission_text, canonical.applicant_name),
      source="submission",
      note="Applicant name should appear in the submission document.",
    ),
    IdentityEvidence(
      key="contact.phone",
      value=present_value(submission_text, canonical.phone),
      source="submission",
      note="Phone number should match the registration form.",
    ),
    IdentityEvidence(
      key="contact.email",
      value=present_value(submission_text, canonical.email),
      source="submission",
      note="Email should match the registration form.",
    ),
    IdentityEvidence(
      key="github.owner",
      value=extract_github_owner(repository),
      source="git remote or moon.mod repository",
      note="Repository owner must match the public GitHub account.",
    ),
    IdentityEvidence(
      key="repository.name",
      value=extract_github_repo(repository),
      source="git remote or moon.mod repository",
      note="Repository name should be the submitted project repository.",
    ),
    IdentityEvidence(
      key="mooncakes.owner",
      value=snapshot.mooncakes_owner,
      source="project snapshot",
      note="Mooncakes owner should match moon.mod owner.",
    ),
    IdentityEvidence(
      key="package.name",
      value=snapshot.mooncakes_package,
      source="project snapshot",
      note="Mooncakes package should match the published package name.",
    ),
    IdentityEvidence(
      key="module.owner",
      value=manifest.owner,
      source="moon.mod name",
      note="Module namespace owner is what moon publish validates.",
    ),
    IdentityEvidence(
      key="module.package",
      value=manifest.package_name,
      source="moon.mod name",
      note="Module package is the public Mooncakes package slug.",
    ),
    IdentityEvidence(
      key="git.user.name",
      value=git_user_name,
      source="git config user.name",
      note="Local commit author name should be the intended GitHub handle or applicant name.",
    ),
    IdentityEvidence(
      key="git.user.email",
      value=git_user_email,
      source="git config user.email",
      note="Local commit email should be the intended applicant email.",
    ),
  ]
}

///|
fn expected_identity_value(
  canonical : SubmissionIdentity,
  key : String,
) -> String {
  match key {
    "applicant.name" => canonical.applicant_name
    "contact.phone" => canonical.phone
    "contact.email" => canonical.email
    "github.owner" => canonical.github_owner
    "repository.name" => canonical.repository_name
    "mooncakes.owner" => canonical.mooncakes_owner
    "package.name" => canonical.package_name
    "module.owner" => canonical.mooncakes_owner
    "module.package" => canonical.package_name
    "git.user.name" => canonical.github_owner
    "git.user.email" => canonical.email
    _ => ""
  }
}

///|
fn identity_pass(
  id : String,
  title : String,
  expected : String,
  actual : String,
  source : String,
) -> IdentityFinding {
  { id, severity: Pass, title, expected, actual, source, detail: "" }
}

///|
fn identity_warn(
  id : String,
  title : String,
  expected : String,
  actual : String,
  source : String,
  detail : String,
) -> IdentityFinding {
  { id, severity: Warn, title, expected, actual, source, detail }
}

///|
fn identity_fail(
  id : String,
  title : String,
  expected : String,
  actual : String,
  source : String,
  detail : String,
) -> IdentityFinding {
  { id, severity: Fail, title, expected, actual, source, detail }
}

///|
fn identity_score(findings : Array[IdentityFinding]) -> Int {
  let mut score = 100
  for finding in findings {
    match finding.severity {
      Pass => ()
      Warn => score -= 4
      Fail => score -= 12
    }
  }
  score.clamp(min=0, max=100)
}

///|
fn identity_verdict(findings : Array[IdentityFinding]) -> String {
  let mut failures = 0
  let mut warnings = 0
  for finding in findings {
    match finding.severity {
      Pass => ()
      Warn => warnings += 1
      Fail => failures += 1
    }
  }
  if failures > 0 {
    "identity-mismatch"
  } else if warnings > 0 {
    "needs-review"
  } else {
    "consistent"
  }
}

///|
fn normalized_identity(value : String) -> String {
  value.trim().to_owned()
}

///|
fn present_value(haystack : String, needle : String) -> String {
  if needle == "" {
    ""
  } else if normalized(haystack).contains(needle) {
    needle
  } else {
    ""
  }
}

///|
fn extract_github_owner(repository : String) -> String {
  let tail = github_tail(repository)
  if tail == "" {
    ""
  } else {
    let parts = tail.split("/").to_array()
    if parts.length() >= 2 {
      parts[0].trim().to_owned()
    } else {
      ""
    }
  }
}

///|
fn extract_github_repo(repository : String) -> String {
  let tail = github_tail(repository)
  if tail == "" {
    ""
  } else {
    let parts = tail.split("/").to_array()
    if parts.length() >= 2 {
      strip_git_suffix(parts[1].trim().to_owned())
    } else {
      ""
    }
  }
}

///|
fn github_tail(repository : String) -> String {
  let trimmed = repository.trim().to_owned()
  if trimmed.contains("github.com/") {
    let parts = trimmed.split("github.com/").to_array()
    if parts.length() >= 2 {
      parts[1].to_owned()
    } else {
      ""
    }
  } else if trimmed.contains("github.com:") {
    let parts = trimmed.split("github.com:").to_array()
    if parts.length() >= 2 {
      parts[1].to_owned()
    } else {
      ""
    }
  } else {
    ""
  }
}

///|
fn strip_git_suffix(repo : String) -> String {
  if repo.has_suffix(".git") {
    repo[0:repo.length() - 4].to_owned()
  } else {
    repo
  }
}
