///|
/// Run the default HarborCheck audit over a project snapshot.
pub fn audit(snapshot : ProjectSnapshot) -> AuditReport {
  run_audit(snapshot)
}

///|
/// Build a compact Markdown report for a project snapshot.
pub fn audit_markdown(snapshot : ProjectSnapshot) -> String {
  audit(snapshot).to_markdown()
}

///|
/// Build a compact JSON summary for integrations that need machine-readable output.
pub fn audit_json(snapshot : ProjectSnapshot) -> String {
  audit(snapshot).to_json()
}

///|
/// Build an actionable checklist from the audit result.
pub fn release_checklist(snapshot : ProjectSnapshot) -> String {
  audit(snapshot).to_release_checklist()
}

///|
/// Check whether applicant, repository, git and Mooncakes identities agree.
pub fn acceptance_identity_markdown(
  canonical : SubmissionIdentity,
  snapshot : ProjectSnapshot,
  submission_text : String,
  git_user_name? : String = "",
  git_user_email? : String = "",
  git_remote? : String = "",
) -> String {
  acceptance_identity_report(
    canonical,
    snapshot,
    submission_text,
    git_user_name~,
    git_user_email~,
    git_remote~,
  ).to_markdown()
}

///|
/// Combine repository audit, identity proof and documentation proof into one final review.
pub fn acceptance_markdown(
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
  final_acceptance_markdown(
    snapshot,
    canonical,
    submission_text,
    markdown,
    sources,
    profile~,
    git_user_name~,
    git_user_email~,
    git_remote~,
  )
}

///|
/// Return the built-in rule catalog in Markdown form.
pub fn rules_markdown() -> String {
  rule_catalog_markdown()
}

///|
/// Return a runnable fixture that demonstrates a release-ready MoonBit package.
pub fn example_snapshot() -> ProjectSnapshot {
  harborcheck_example_snapshot()
}
