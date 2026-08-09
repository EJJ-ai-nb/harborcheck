///|
pub(all) struct RepairStep {
  id : String
  kind : CheckKind
  severity : Severity
  title : String
  action : String
  blocking : Bool
} derive(Eq, Debug)

///|
pub fn AuditReport::has_blockers(self : AuditReport) -> Bool {
  self.metrics.fail_count > 0
}

///|
pub fn AuditReport::repair_steps(self : AuditReport) -> Array[RepairStep] {
  let steps = Array::new(capacity=self.findings.length())
  for finding in self.findings {
    if finding.severity != Pass {
      steps.push({
        id: finding.id,
        kind: finding.kind,
        severity: finding.severity,
        title: finding.title,
        action: repair_action(finding),
        blocking: finding.severity == Fail,
      })
    }
  }
  steps
}

///|
pub fn AuditReport::to_release_checklist(self : AuditReport) -> String {
  let out = StringBuilder()
  out.write_string("# Release Checklist\n\n")
  out.write_string(
    "- Score: " +
    self.score.to_string() +
    "/" +
    self.max_score.to_string() +
    "\n",
  )
  out.write_string("- Verdict: " + self.verdict + "\n")
  out.write_string(
    "- Blocking findings: " + self.metrics.fail_count.to_string() + "\n\n",
  )
  let steps = self.repair_steps()
  if steps.length() == 0 {
    out.write_string(
      "All checks pass. Run `moon publish --dry-run`, then publish with an authenticated Mooncakes account.\n",
    )
  } else {
    out.write_string("## Required Actions\n\n")
    for step in steps {
      let mark = if step.blocking { "[blocking]" } else { "[advisory]" }
      out.write_string("- " + mark + " " + step.id + ": " + step.action + "\n")
    }
  }
  out.to_string()
}

///|
fn repair_action(finding : Finding) -> String {
  if finding.repair != "" {
    finding.repair
  } else if finding.detail != "" {
    finding.detail
  } else {
    "Review " + finding.title + "."
  }
}
