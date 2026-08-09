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
/// Return the built-in rule catalog in Markdown form.
pub fn rules_markdown() -> String {
  rule_catalog_markdown()
}

///|
/// Return a runnable fixture that demonstrates a release-ready MoonBit package.
pub fn example_snapshot() -> ProjectSnapshot {
  harborcheck_example_snapshot()
}
