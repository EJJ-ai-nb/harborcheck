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
/// Return a runnable fixture that demonstrates a release-ready MoonBit package.
pub fn example_snapshot() -> ProjectSnapshot {
  harborcheck_example_snapshot()
}
