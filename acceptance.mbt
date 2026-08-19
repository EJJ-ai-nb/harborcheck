///|
pub(all) struct AcceptanceProfile {
  effective_moonbit_loc : Int
  target_moonbit_loc : Int
  ci_status : String
  mooncakes_build_status : String
  latest_commit_author : String
  latest_commit_email : String
  contest_commit_count : Int
  published_version : String
} derive(Eq, Debug)

///|
pub fn AcceptanceProfile::AcceptanceProfile(
  effective_moonbit_loc? : Int = 0,
  target_moonbit_loc? : Int = 4000,
  ci_status? : String = "",
  mooncakes_build_status? : String = "",
  latest_commit_author? : String = "",
  latest_commit_email? : String = "",
  contest_commit_count? : Int = 0,
  published_version? : String = "",
) -> AcceptanceProfile {
  {
    effective_moonbit_loc,
    target_moonbit_loc,
    ci_status,
    mooncakes_build_status,
    latest_commit_author,
    latest_commit_email,
    contest_commit_count,
    published_version,
  }
}

///|
pub(all) struct AcceptanceSignal {
  id : String
  severity : Severity
  title : String
  evidence : String
  action : String
  hard_blocker : Bool
} derive(Eq, Debug)

///|
pub(all) struct AcceptanceReview {
  audit : AuditReport
  identity : IdentityReport
  doc_proof : DocProofReport
  profile : AcceptanceProfile
  signals : Array[AcceptanceSignal]
  score : Int
  verdict : String
} derive(Eq, Debug)

///|
pub fn final_acceptance_review(
  snapshot : ProjectSnapshot,
  canonical : SubmissionIdentity,
  submission_text : String,
  markdown : String,
  sources : Array[SourceEvidence],
  profile? : AcceptanceProfile = AcceptanceProfile::AcceptanceProfile(),
  git_user_name? : String = "",
  git_user_email? : String = "",
  git_remote? : String = "",
) -> AcceptanceReview {
  let audit_report = audit(snapshot)
  let identity_report = acceptance_identity_report(
    canonical,
    snapshot,
    submission_text,
    git_user_name~,
    git_user_email~,
    git_remote~,
  )
  let proof = doc_proof(markdown, sources)
  let signals = acceptance_signals(
    audit_report, identity_report, proof, profile,
  )
  let score = acceptance_score(
    audit_report, identity_report, proof, profile, signals,
  )
  {
    audit: audit_report,
    identity: identity_report,
    doc_proof: proof,
    profile,
    signals,
    score,
    verdict: acceptance_verdict(signals, score),
  }
}

///|
pub fn final_acceptance_markdown(
  snapshot : ProjectSnapshot,
  canonical : SubmissionIdentity,
  submission_text : String,
  markdown : String,
  sources : Array[SourceEvidence],
  profile? : AcceptanceProfile = AcceptanceProfile::AcceptanceProfile(),
  git_user_name? : String = "",
  git_user_email? : String = "",
  git_remote? : String = "",
) -> String {
  final_acceptance_review(
    snapshot,
    canonical,
    submission_text,
    markdown,
    sources,
    profile~,
    git_user_name~,
    git_user_email~,
    git_remote~,
  ).to_markdown()
}

///|
pub fn final_acceptance_json(
  snapshot : ProjectSnapshot,
  canonical : SubmissionIdentity,
  submission_text : String,
  markdown : String,
  sources : Array[SourceEvidence],
  profile? : AcceptanceProfile = AcceptanceProfile::AcceptanceProfile(),
  git_user_name? : String = "",
  git_user_email? : String = "",
  git_remote? : String = "",
) -> String {
  final_acceptance_review(
    snapshot,
    canonical,
    submission_text,
    markdown,
    sources,
    profile~,
    git_user_name~,
    git_user_email~,
    git_remote~,
  ).to_json()
}

///|
pub fn AcceptanceReview::has_hard_blockers(self : AcceptanceReview) -> Bool {
  for signal in self.signals {
    if signal.hard_blocker {
      return true
    }
  }
  false
}

///|
pub fn AcceptanceReview::hard_blocker_count(self : AcceptanceReview) -> Int {
  let mut total = 0
  for signal in self.signals {
    if signal.hard_blocker {
      total += 1
    }
  }
  total
}

///|
pub fn AcceptanceReview::warning_count(self : AcceptanceReview) -> Int {
  let mut total = 0
  for signal in self.signals {
    if signal.severity == Warn {
      total += 1
    }
  }
  total
}

///|
pub fn AcceptanceReview::line_gap(self : AcceptanceReview) -> Int {
  loc_gap(self.profile)
}

///|
pub fn AcceptanceReview::to_markdown(self : AcceptanceReview) -> String {
  let out = StringBuilder()
  out.write_string("# HarborCheck Final Acceptance Review\n\n")
  out.write_string("- Verdict: " + self.verdict + "\n")
  out.write_string("- Score: " + self.score.to_string() + "/100\n")
  out.write_string("- Audit verdict: " + self.audit.verdict + "\n")
  out.write_string("- Identity verdict: " + self.identity.verdict + "\n")
  out.write_string("- Doc proof verdict: " + self.doc_proof.verdict + "\n")
  out.write_string(
    "- Effective MoonBit LOC: " +
    self.profile.effective_moonbit_loc.to_string() +
    "/" +
    self.profile.target_moonbit_loc.to_string() +
    "\n",
  )
  out.write_string(
    "- Hard blockers: " + self.hard_blocker_count().to_string() + "\n",
  )
  out.write_string("- Warnings: " + self.warning_count().to_string() + "\n\n")
  out.write_string("## Signals\n\n")
  for signal in self.signals {
    out.write_string("- [" + severity_text(signal.severity) + "] ")
    out.write_string(signal.id + ": " + signal.title)
    if signal.evidence != "" {
      out.write_string(" -- " + signal.evidence)
    }
    if signal.severity != Pass && signal.action != "" {
      out.write_string(" Action: " + signal.action)
    }
    out.write_string("\n")
  }
  out.write_string("\n## Next Actions\n\n")
  let actions = self.next_actions()
  if actions.length() == 0 {
    out.write_string("- Keep CI green and submit the current public links.\n")
  } else {
    for action in actions {
      out.write_string("- " + action + "\n")
    }
  }
  out.to_string()
}

///|
pub fn AcceptanceReview::to_json(self : AcceptanceReview) -> String {
  let out = StringBuilder()
  out.write_string("{")
  out.write_string("\"verdict\":\"" + json_escape(self.verdict) + "\",")
  out.write_string("\"score\":" + self.score.to_string() + ",")
  out.write_string(
    "\"hard_blockers\":" + self.hard_blocker_count().to_string() + ",",
  )
  out.write_string("\"warnings\":" + self.warning_count().to_string() + ",")
  out.write_string(
    "\"effective_moonbit_loc\":" +
    self.profile.effective_moonbit_loc.to_string() +
    ",",
  )
  out.write_string(
    "\"target_moonbit_loc\":" +
    self.profile.target_moonbit_loc.to_string() +
    ",",
  )
  out.write_string("\"audit\":\"" + json_escape(self.audit.verdict) + "\",")
  out.write_string(
    "\"identity\":\"" + json_escape(self.identity.verdict) + "\",",
  )
  out.write_string(
    "\"doc_proof\":\"" + json_escape(self.doc_proof.verdict) + "\",",
  )
  out.write_string("\"signals\":[")
  for i in 0..<self.signals.length() {
    let signal = self.signals[i]
    if i > 0 {
      out.write_string(",")
    }
    out.write_string("{")
    out.write_string("\"id\":\"" + json_escape(signal.id) + "\",")
    out.write_string("\"severity\":\"" + severity_text(signal.severity) + "\",")
    out.write_string("\"title\":\"" + json_escape(signal.title) + "\",")
    out.write_string("\"evidence\":\"" + json_escape(signal.evidence) + "\",")
    out.write_string("\"hard_blocker\":" + signal.hard_blocker.to_string())
    out.write_string("}")
  }
  out.write_string("]}")
  out.to_string()
}

///|
pub fn AcceptanceReview::next_actions(self : AcceptanceReview) -> Array[String] {
  let actions = Array::new(capacity=self.signals.length())
  for signal in self.signals {
    if signal.severity != Pass && signal.action != "" {
      actions.push(signal.action)
    }
  }
  actions
}

///|
fn acceptance_signals(
  audit_report : AuditReport,
  identity_report : IdentityReport,
  proof : DocProofReport,
  profile : AcceptanceProfile,
) -> Array[AcceptanceSignal] {
  let signals = Array::new(capacity=16)
  push_audit_signal(signals, audit_report)
  push_identity_signal(signals, identity_report)
  push_doc_signal(signals, proof)
  push_loc_signal(signals, profile)
  push_ci_status_signal(signals, profile)
  push_mooncakes_status_signal(signals, profile)
  push_commit_signal(signals, profile)
  push_version_signal(signals, profile)
  signals
}

///|
fn push_audit_signal(
  signals : Array[AcceptanceSignal],
  report : AuditReport,
) -> Unit {
  if report.metrics.fail_count == 0 {
    signals.push(
      acceptance_pass(
        "audit.ready",
        "Repository checklist has no blocking failures",
        report.score.to_string() + "/100",
      ),
    )
  } else {
    signals.push(
      acceptance_fail(
        "audit.blockers",
        "Repository checklist has blocking failures",
        report.metrics.fail_count.to_string() + " fail findings",
        "Fix the audit report before submitting final acceptance evidence.",
        true,
      ),
    )
  }
}

///|
fn push_identity_signal(
  signals : Array[AcceptanceSignal],
  report : IdentityReport,
) -> Unit {
  if report.verdict == "consistent" {
    signals.push(
      acceptance_pass(
        "identity.consistent",
        "Applicant, GitHub and Mooncakes identities are consistent",
        report.matching_count().to_string() + " matching evidence items",
      ),
    )
  } else {
    signals.push(
      acceptance_fail(
        "identity.mismatch",
        "Identity evidence is inconsistent",
        report.mismatch_count().to_string() + " mismatches",
        "Keep applicant name, email, GitHub owner, git author and Mooncakes namespace aligned.",
        true,
      ),
    )
  }
}

///|
fn push_doc_signal(
  signals : Array[AcceptanceSignal],
  proof : DocProofReport,
) -> Unit {
  if proof.verdict == "ready" {
    signals.push(
      acceptance_pass(
        "doc-proof.ready",
        "README examples and source records are reviewable",
        proof.runnable_snippet_count.to_string() + " runnable snippets",
      ),
    )
  } else {
    signals.push(
      acceptance_fail(
        "doc-proof.needs-work",
        "README examples or source records need work",
        proof.verdict,
        "Add runnable MoonBit snippets and clear source/license evidence.",
        true,
      ),
    )
  }
}

///|
fn push_loc_signal(
  signals : Array[AcceptanceSignal],
  profile : AcceptanceProfile,
) -> Unit {
  let gap = loc_gap(profile)
  if profile.effective_moonbit_loc <= 0 {
    signals.push(
      acceptance_warn(
        "scale.unknown", "Effective MoonBit LOC was not provided", "unknown", "Count nonblank non-comment .mbt lines before final submission.",
      ),
    )
  } else if gap <= 0 {
    signals.push(
      acceptance_pass(
        "scale.target-met",
        "Effective MoonBit LOC reaches the reference target",
        profile.effective_moonbit_loc.to_string() +
        "/" +
        profile.target_moonbit_loc.to_string(),
      ),
    )
  } else {
    signals.push(
      acceptance_warn(
        "scale.below-reference",
        "Effective MoonBit LOC is below the reference scale",
        profile.effective_moonbit_loc.to_string() +
        "/" +
        profile.target_moonbit_loc.to_string() +
        " gap=" +
        gap.to_string(),
        "Prefer adding real reviewer-facing capability instead of padding code.",
      ),
    )
  }
}

///|
fn push_ci_status_signal(
  signals : Array[AcceptanceSignal],
  profile : AcceptanceProfile,
) -> Unit {
  let status = lower(profile.ci_status)
  if status == "success" || status == "passed" {
    signals.push(
      acceptance_pass(
        "ci.remote-success",
        "Remote CI is successful",
        profile.ci_status,
      ),
    )
  } else if status == "" {
    signals.push(
      acceptance_warn(
        "ci.status-unknown", "Remote CI status was not provided", "unknown", "Open GitHub Actions and confirm the latest main-branch run is successful.",
      ),
    )
  } else {
    signals.push(
      acceptance_fail(
        "ci.remote-failed",
        "Remote CI is not successful",
        profile.ci_status,
        "Fix GitHub Actions before final acceptance.",
        true,
      ),
    )
  }
}

///|
fn push_mooncakes_status_signal(
  signals : Array[AcceptanceSignal],
  profile : AcceptanceProfile,
) -> Unit {
  let status = lower(profile.mooncakes_build_status)
  if status == "success" || status == "passed" {
    signals.push(
      acceptance_pass(
        "mooncakes.build-success",
        "Mooncakes build status is successful",
        profile.mooncakes_build_status,
      ),
    )
  } else if status == "" {
    signals.push(
      acceptance_warn(
        "mooncakes.status-unknown", "Mooncakes build status was not provided", "unknown",
        "Check the Mooncakes manifest before final acceptance.",
      ),
    )
  } else {
    signals.push(
      acceptance_fail(
        "mooncakes.build-failed",
        "Mooncakes build status is not successful",
        profile.mooncakes_build_status,
        "Republish or fix package docs until Mooncakes reports success.",
        true,
      ),
    )
  }
}

///|
fn push_commit_signal(
  signals : Array[AcceptanceSignal],
  profile : AcceptanceProfile,
) -> Unit {
  if profile.contest_commit_count >= 5 {
    signals.push(
      acceptance_pass(
        "git.contest-history",
        "Contest-period commit history is traceable",
        profile.contest_commit_count.to_string() + " commits",
      ),
    )
  } else {
    signals.push(
      acceptance_warn(
        "git.short-history",
        "Contest-period commit history is short",
        profile.contest_commit_count.to_string() + " commits",
        "Keep meaningful implementation, test, documentation and release commits.",
      ),
    )
  }
  if profile.latest_commit_author != "" || profile.latest_commit_email != "" {
    signals.push(
      acceptance_pass(
        "git.latest-author",
        "Latest commit author evidence is recorded",
        profile.latest_commit_author + " <" + profile.latest_commit_email + ">",
      ),
    )
  } else {
    signals.push(
      acceptance_warn(
        "git.latest-author-unknown", "Latest commit author evidence was not provided",
        "unknown", "Record the latest commit author when preparing final acceptance notes.",
      ),
    )
  }
}

///|
fn push_version_signal(
  signals : Array[AcceptanceSignal],
  profile : AcceptanceProfile,
) -> Unit {
  if semver_like(profile.published_version) {
    signals.push(
      acceptance_pass(
        "release.version",
        "Published version is SemVer-like",
        profile.published_version,
      ),
    )
  } else if profile.published_version == "" {
    signals.push(
      acceptance_warn(
        "release.version-unknown", "Published version was not provided", "unknown",
        "Record the published Mooncakes version in final notes.",
      ),
    )
  } else {
    signals.push(
      acceptance_warn(
        "release.version-format",
        "Published version does not look like x.y.z",
        profile.published_version,
        "Use SemVer-style versions for Mooncakes releases.",
      ),
    )
  }
}

///|
fn acceptance_pass(
  id : String,
  title : String,
  evidence : String,
) -> AcceptanceSignal {
  { id, severity: Pass, title, evidence, action: "", hard_blocker: false }
}

///|
fn acceptance_warn(
  id : String,
  title : String,
  evidence : String,
  action : String,
) -> AcceptanceSignal {
  { id, severity: Warn, title, evidence, action, hard_blocker: false }
}

///|
fn acceptance_fail(
  id : String,
  title : String,
  evidence : String,
  action : String,
  hard_blocker : Bool,
) -> AcceptanceSignal {
  { id, severity: Fail, title, evidence, action, hard_blocker }
}

///|
fn loc_gap(profile : AcceptanceProfile) -> Int {
  if profile.target_moonbit_loc <= profile.effective_moonbit_loc {
    0
  } else {
    profile.target_moonbit_loc - profile.effective_moonbit_loc
  }
}

///|
fn acceptance_score(
  audit_report : AuditReport,
  identity_report : IdentityReport,
  proof : DocProofReport,
  profile : AcceptanceProfile,
  signals : Array[AcceptanceSignal],
) -> Int {
  let mut score = 100
  score -= (100 - audit_report.score) / 2
  score -= (100 - identity_report.score) / 2
  if proof.verdict != "ready" {
    score -= 18
  }
  if loc_gap(profile) > 0 && profile.effective_moonbit_loc > 0 {
    score -= 4
  }
  for signal in signals {
    match signal.severity {
      Pass => ()
      Warn => score -= 2
      Fail => score -= 12
    }
  }
  score.clamp(min=0, max=100)
}

///|
fn acceptance_verdict(signals : Array[AcceptanceSignal], score : Int) -> String {
  let mut blockers = 0
  let mut warnings = 0
  for signal in signals {
    if signal.hard_blocker {
      blockers += 1
    } else if signal.severity == Warn {
      warnings += 1
    }
  }
  if blockers > 0 {
    "blocked"
  } else if score >= 90 && warnings == 0 {
    "acceptance-ready"
  } else if score >= 80 {
    "review-ready-with-notes"
  } else {
    "needs-polish"
  }
}
