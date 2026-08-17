///|
fn severity_text(severity : Severity) -> String {
  match severity {
    Pass => "pass"
    Warn => "warn"
    Fail => "fail"
  }
}

///|
fn kind_text(kind : CheckKind) -> String {
  match kind {
    PackageConfig => "package"
    Readme => "readme"
    ContinuousIntegration => "ci"
    Tests => "tests"
    Examples => "examples"
    Build => "build"
    Mooncakes => "mooncakes"
    GitTrace => "git"
    License => "license"
    Boundary => "boundary"
    DocProof => "doc-proof"
  }
}

///|
pub fn AuditReport::to_markdown(self : AuditReport) -> String {
  let out = StringBuilder()
  out.write_string("# HarborCheck Audit\n\n")
  out.write_string("- Project: " + self.project_name + "\n")
  out.write_string("- Package: " + self.package_name + "\n")
  out.write_string("- Repository: " + self.repository + "\n")
  out.write_string(
    "- Score: " +
    self.score.to_string() +
    "/" +
    self.max_score.to_string() +
    "\n",
  )
  out.write_string("- Verdict: " + self.verdict + "\n\n")
  out.write_string("## Metrics\n\n")
  out.write_string("- Pass: " + self.metrics.pass_count.to_string() + "\n")
  out.write_string("- Warn: " + self.metrics.warn_count.to_string() + "\n")
  out.write_string("- Fail: " + self.metrics.fail_count.to_string() + "\n")
  out.write_string(
    "- Commands: " + self.metrics.command_count.to_string() + "\n",
  )
  out.write_string(
    "- Tests: " + self.metrics.test_fixture_count.to_string() + "\n",
  )
  out.write_string(
    "- Examples: " + self.metrics.example_count.to_string() + "\n\n",
  )
  out.write_string("## Findings\n\n")
  for finding in self.findings {
    out.write_string("- [" + severity_text(finding.severity) + "] ")
    out.write_string(finding.id + " (" + kind_text(finding.kind) + "): ")
    out.write_string(finding.title)
    if finding.evidence != "" {
      out.write_string(" -- " + finding.evidence)
    }
    if finding.repair != "" && finding.severity != Pass {
      out.write_string(" Fix: " + finding.repair)
    }
    out.write_string("\n")
  }
  out.to_string()
}

///|
pub fn AuditReport::to_json(self : AuditReport) -> String {
  let out = StringBuilder()
  out.write_string("{")
  out.write_string("\"project\":\"" + json_escape(self.project_name) + "\",")
  out.write_string("\"package\":\"" + json_escape(self.package_name) + "\",")
  out.write_string("\"repository\":\"" + json_escape(self.repository) + "\",")
  out.write_string("\"score\":" + self.score.to_string() + ",")
  out.write_string("\"max_score\":" + self.max_score.to_string() + ",")
  out.write_string("\"verdict\":\"" + json_escape(self.verdict) + "\",")
  out.write_string("\"metrics\":{")
  out.write_string("\"pass\":" + self.metrics.pass_count.to_string() + ",")
  out.write_string("\"warn\":" + self.metrics.warn_count.to_string() + ",")
  out.write_string("\"fail\":" + self.metrics.fail_count.to_string() + ",")
  out.write_string(
    "\"commands\":" + self.metrics.command_count.to_string() + ",",
  )
  out.write_string(
    "\"tests\":" + self.metrics.test_fixture_count.to_string() + ",",
  )
  out.write_string("\"examples\":" + self.metrics.example_count.to_string())
  out.write_string("},")
  out.write_string("\"findings\":[")
  for i in 0..<self.findings.length() {
    let finding = self.findings[i]
    if i > 0 {
      out.write_string(",")
    }
    out.write_string("{")
    out.write_string("\"id\":\"" + json_escape(finding.id) + "\",")
    out.write_string("\"kind\":\"" + kind_text(finding.kind) + "\",")
    out.write_string(
      "\"severity\":\"" + severity_text(finding.severity) + "\",",
    )
    out.write_string("\"title\":\"" + json_escape(finding.title) + "\",")
    out.write_string("\"detail\":\"" + json_escape(finding.detail) + "\",")
    out.write_string("\"repair\":\"" + json_escape(finding.repair) + "\",")
    out.write_string("\"evidence\":\"" + json_escape(finding.evidence) + "\",")
    out.write_string("\"penalty\":" + finding.penalty.to_string())
    out.write_string("}")
  }
  out.write_string("]}")
  out.to_string()
}
