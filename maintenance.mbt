///|
pub(all) enum MaintenanceRecordKind {
  IssueRecord
  PullRequestRecord
  TestRecord
  ChangelogEntry
  ReleaseRecord
  DesignDecision
  LicenseNote
  CiRunRecord
} derive(Eq, Debug)

///|
pub(all) enum MaintenanceState {
  Planned
  InProgress
  Done
  Deferred
  BlockedState
} derive(Eq, Debug)

///|
pub(all) struct MaintenanceRecord {
  id : String
  kind : MaintenanceRecordKind
  title : String
  state : MaintenanceState
  evidence : String
  link : String
  owner : String
  date : String
  note : String
} derive(Eq, Debug)

///|
pub fn MaintenanceRecord::MaintenanceRecord(
  id? : String = "",
  kind? : MaintenanceRecordKind = IssueRecord,
  title? : String = "",
  state? : MaintenanceState = Done,
  evidence? : String = "",
  link? : String = "",
  owner? : String = "",
  date? : String = "",
  note? : String = "",
) -> MaintenanceRecord {
  { id, kind, title, state, evidence, link, owner, date, note }
}

///|
pub(all) struct MaintenancePolicy {
  min_issue_records : Int
  min_test_records : Int
  require_changelog : Bool
  require_release : Bool
  require_design_notes : Bool
  require_license_note : Bool
  require_ci_record : Bool
  require_evidence_for_done : Bool
} derive(Eq, Debug)

///|
pub fn MaintenancePolicy::MaintenancePolicy(
  min_issue_records? : Int = 1,
  min_test_records? : Int = 1,
  require_changelog? : Bool = true,
  require_release? : Bool = true,
  require_design_notes? : Bool = true,
  require_license_note? : Bool = true,
  require_ci_record? : Bool = true,
  require_evidence_for_done? : Bool = true,
) -> MaintenancePolicy {
  {
    min_issue_records,
    min_test_records,
    require_changelog,
    require_release,
    require_design_notes,
    require_license_note,
    require_ci_record,
    require_evidence_for_done,
  }
}

///|
pub(all) struct MaintenanceFinding {
  id : String
  severity : Severity
  title : String
  detail : String
  repair : String
  evidence : String
  penalty : Int
} derive(Eq, Debug)

///|
pub(all) struct MaintenanceReport {
  score : Int
  verdict : String
  records : Array[MaintenanceRecord]
  findings : Array[MaintenanceFinding]
  record_count : Int
  completed_count : Int
  open_count : Int
  evidence_count : Int
  issue_count : Int
  test_count : Int
  release_count : Int
  changelog_count : Int
  design_count : Int
  ci_count : Int
  license_count : Int
} derive(Eq, Debug)

///|
pub fn maintenance_review(
  records : Array[MaintenanceRecord],
  policy? : MaintenancePolicy = MaintenancePolicy::MaintenancePolicy(),
) -> MaintenanceReport {
  let findings = maintenance_findings(records, policy)
  let score = maintenance_score(findings)
  let completed_count = count_records_by_state(records, Done)
  let open_count = records.length() - completed_count
  let evidence_count = count_records_with_evidence(records)
  {
    score,
    verdict: maintenance_verdict(findings, score),
    records,
    findings,
    record_count: records.length(),
    completed_count,
    open_count,
    evidence_count,
    issue_count: count_records_by_kind(records, IssueRecord),
    test_count: count_records_by_kind(records, TestRecord),
    release_count: count_records_by_kind(records, ReleaseRecord),
    changelog_count: count_records_by_kind(records, ChangelogEntry),
    design_count: count_records_by_kind(records, DesignDecision),
    ci_count: count_records_by_kind(records, CiRunRecord),
    license_count: count_records_by_kind(records, LicenseNote),
  }
}

///|
pub fn maintenance_markdown(
  records : Array[MaintenanceRecord],
  policy? : MaintenancePolicy = MaintenancePolicy::MaintenancePolicy(),
) -> String {
  maintenance_review(records, policy~).to_markdown()
}

///|
pub fn maintenance_json(
  records : Array[MaintenanceRecord],
  policy? : MaintenancePolicy = MaintenancePolicy::MaintenancePolicy(),
) -> String {
  maintenance_review(records, policy~).to_json()
}

///|
pub fn MaintenanceReport::has_blockers(self : MaintenanceReport) -> Bool {
  for finding in self.findings {
    if finding.severity == Fail {
      return true
    }
  }
  false
}

///|
pub fn MaintenanceReport::warning_count(self : MaintenanceReport) -> Int {
  let mut total = 0
  for finding in self.findings {
    if finding.severity == Warn {
      total += 1
    }
  }
  total
}

///|
pub fn MaintenanceReport::repair_steps(
  self : MaintenanceReport,
) -> Array[String] {
  let steps = Array::new(capacity=self.findings.length())
  for finding in self.findings {
    if finding.severity != Pass && finding.repair != "" {
      steps.push(finding.repair)
    }
  }
  steps
}

///|
pub fn MaintenanceReport::records_for_kind(
  self : MaintenanceReport,
  kind : MaintenanceRecordKind,
) -> Array[MaintenanceRecord] {
  let out = Array::new(capacity=self.records.length())
  for record in self.records {
    if record.kind == kind {
      out.push(record)
    }
  }
  out
}

///|
pub fn MaintenanceReport::to_markdown(self : MaintenanceReport) -> String {
  let out = StringBuilder()
  out.write_string("# HarborCheck Maintenance Evidence\n\n")
  out.write_string("- Verdict: " + self.verdict + "\n")
  out.write_string("- Score: " + self.score.to_string() + "/100\n")
  out.write_string("- Records: " + self.record_count.to_string() + "\n")
  out.write_string("- Completed: " + self.completed_count.to_string() + "\n")
  out.write_string("- Open: " + self.open_count.to_string() + "\n")
  out.write_string(
    "- Evidence-backed: " + self.evidence_count.to_string() + "\n\n",
  )
  out.write_string("## Coverage\n\n")
  out.write_string("- Issues: " + self.issue_count.to_string() + "\n")
  out.write_string("- Tests: " + self.test_count.to_string() + "\n")
  out.write_string("- Changelog: " + self.changelog_count.to_string() + "\n")
  out.write_string("- Releases: " + self.release_count.to_string() + "\n")
  out.write_string(
    "- Design decisions: " + self.design_count.to_string() + "\n",
  )
  out.write_string("- CI runs: " + self.ci_count.to_string() + "\n")
  out.write_string(
    "- License notes: " + self.license_count.to_string() + "\n\n",
  )
  out.write_string("## Findings\n\n")
  for finding in self.findings {
    out.write_string("- [" + severity_text(finding.severity) + "] ")
    out.write_string(finding.id + ": " + finding.title)
    if finding.evidence != "" {
      out.write_string(" -- " + finding.evidence)
    }
    if finding.repair != "" && finding.severity != Pass {
      out.write_string(" Fix: " + finding.repair)
    }
    out.write_string("\n")
  }
  out.write_string("\n## Records\n\n")
  for record in self.records {
    out.write_string("- " + record.id + " ")
    out.write_string("(" + maintenance_kind_text(record.kind) + ", ")
    out.write_string(maintenance_state_text(record.state) + "): ")
    out.write_string(record.title)
    if record.evidence != "" {
      out.write_string(" -- " + record.evidence)
    } else if record.link != "" {
      out.write_string(" -- " + record.link)
    }
    out.write_string("\n")
  }
  out.to_string()
}

///|
pub fn MaintenanceReport::to_json(self : MaintenanceReport) -> String {
  let out = StringBuilder()
  out.write_string("{")
  out.write_string("\"verdict\":\"" + json_escape(self.verdict) + "\",")
  out.write_string("\"score\":" + self.score.to_string() + ",")
  out.write_string("\"record_count\":" + self.record_count.to_string() + ",")
  out.write_string(
    "\"completed_count\":" + self.completed_count.to_string() + ",",
  )
  out.write_string("\"open_count\":" + self.open_count.to_string() + ",")
  out.write_string(
    "\"evidence_count\":" + self.evidence_count.to_string() + ",",
  )
  out.write_string("\"coverage\":{")
  out.write_string("\"issues\":" + self.issue_count.to_string() + ",")
  out.write_string("\"tests\":" + self.test_count.to_string() + ",")
  out.write_string("\"changelog\":" + self.changelog_count.to_string() + ",")
  out.write_string("\"releases\":" + self.release_count.to_string() + ",")
  out.write_string("\"design\":" + self.design_count.to_string() + ",")
  out.write_string("\"ci\":" + self.ci_count.to_string() + ",")
  out.write_string("\"license\":" + self.license_count.to_string())
  out.write_string("},")
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
    out.write_string("\"title\":\"" + json_escape(finding.title) + "\",")
    out.write_string("\"detail\":\"" + json_escape(finding.detail) + "\",")
    out.write_string("\"repair\":\"" + json_escape(finding.repair) + "\",")
    out.write_string("\"evidence\":\"" + json_escape(finding.evidence) + "\"")
    out.write_string("}")
  }
  out.write_string("],")
  out.write_string("\"records\":[")
  for i in 0..<self.records.length() {
    let record = self.records[i]
    if i > 0 {
      out.write_string(",")
    }
    out.write_string("{")
    out.write_string("\"id\":\"" + json_escape(record.id) + "\",")
    out.write_string("\"kind\":\"" + maintenance_kind_text(record.kind) + "\",")
    out.write_string(
      "\"state\":\"" + maintenance_state_text(record.state) + "\",",
    )
    out.write_string("\"title\":\"" + json_escape(record.title) + "\",")
    out.write_string("\"evidence\":\"" + json_escape(record.evidence) + "\",")
    out.write_string("\"link\":\"" + json_escape(record.link) + "\",")
    out.write_string("\"owner\":\"" + json_escape(record.owner) + "\",")
    out.write_string("\"date\":\"" + json_escape(record.date) + "\"")
    out.write_string("}")
  }
  out.write_string("]}")
  out.to_string()
}

///|
pub fn example_maintenance_records() -> Array[MaintenanceRecord] {
  [
    MaintenanceRecord(
      id="issue-001",
      kind=IssueRecord,
      title="Define README example and provenance proof boundary",
      state=Done,
      evidence="docs/design.md and docs/issues.md",
      owner="EJJ-ai-nb",
      date="2026-08-17",
      note="Tracks the project scope expected by reviewers.",
    ),
    MaintenanceRecord(
      id="test-001",
      kind=TestRecord,
      title="Run check, build, test, fmt, docs and runnable examples",
      state=Done,
      evidence="docs/test-record.md",
      owner="EJJ-ai-nb",
      date="2026-08-20",
      note="Local verification and CI evidence are both retained.",
    ),
    MaintenanceRecord(
      id="change-001",
      kind=ChangelogEntry,
      title="Record release changes for 0.1.x packages",
      state=Done,
      evidence="CHANGELOG.md",
      owner="EJJ-ai-nb",
      date="2026-08-20",
    ),
    MaintenanceRecord(
      id="release-001",
      kind=ReleaseRecord,
      title="Publish HarborCheck to Mooncakes",
      state=Done,
      evidence="EJJ-ai-nb/harborcheck 0.1.4",
      link="https://mooncakes.io/docs/EJJ-ai-nb/harborcheck",
      owner="EJJ-ai-nb",
      date="2026-08-20",
    ),
    MaintenanceRecord(
      id="design-001",
      kind=DesignDecision,
      title="Keep HarborCheck pure MoonBit and snapshot-driven",
      state=Done,
      evidence="docs/design.md",
      owner="EJJ-ai-nb",
      date="2026-08-20",
    ),
    MaintenanceRecord(
      id="ci-001",
      kind=CiRunRecord,
      title="GitHub Actions verifies check, build, test and examples",
      state=Done,
      evidence="ci success on main",
      link="https://github.com/EJJ-ai-nb/harborcheck/actions",
      owner="EJJ-ai-nb",
      date="2026-08-20",
    ),
    MaintenanceRecord(
      id="license-001",
      kind=LicenseNote,
      title="Document MIT license and absence of bundled third-party assets",
      state=Done,
      evidence="LICENSE and README license section",
      owner="EJJ-ai-nb",
      date="2026-08-20",
    ),
  ]
}

///|
fn maintenance_findings(
  records : Array[MaintenanceRecord],
  policy : MaintenancePolicy,
) -> Array[MaintenanceFinding] {
  let findings = Array::new(capacity=12)
  push_record_volume_finding(findings, records)
  push_kind_minimum_finding(
    findings,
    records,
    IssueRecord,
    policy.min_issue_records,
    "trace.issues",
    "Issue or work-item records are retained",
    "Add a concise issue/work-item record for the implemented scope.",
  )
  push_kind_minimum_finding(
    findings,
    records,
    TestRecord,
    policy.min_test_records,
    "trace.tests",
    "Test records are retained",
    "Record the latest local and CI verification commands.",
  )
  push_required_kind_finding(
    findings,
    records,
    ChangelogEntry,
    policy.require_changelog,
    "trace.changelog",
    "Changelog evidence is retained",
    "Add or update CHANGELOG.md for the published version.",
  )
  push_required_kind_finding(
    findings,
    records,
    ReleaseRecord,
    policy.require_release,
    "trace.release",
    "Version release evidence is retained",
    "Record the Mooncakes package version and release link.",
  )
  push_required_kind_finding(
    findings,
    records,
    DesignDecision,
    policy.require_design_notes,
    "trace.design",
    "Design notes are retained",
    "Add a short technical decision note or design document.",
  )
  push_required_kind_finding(
    findings,
    records,
    CiRunRecord,
    policy.require_ci_record,
    "trace.ci",
    "CI run evidence is retained",
    "Record the latest green main-branch CI run.",
  )
  push_required_kind_finding(
    findings,
    records,
    LicenseNote,
    policy.require_license_note,
    "trace.license",
    "License and source notes are retained",
    "Record the project license and any third-party source notes.",
  )
  if policy.require_evidence_for_done {
    push_done_evidence_finding(findings, records)
  }
  push_open_work_finding(findings, records)
  findings
}

///|
fn push_record_volume_finding(
  findings : Array[MaintenanceFinding],
  records : Array[MaintenanceRecord],
) -> Unit {
  if records.length() >= 5 {
    findings.push(
      maintenance_pass(
        "trace.volume",
        "Development evidence has enough records",
        records.length().to_string() + " records",
      ),
    )
  } else if records.length() > 0 {
    findings.push(
      maintenance_warn(
        "trace.volume",
        "Development evidence is thin",
        records.length().to_string() + " records",
        "Keep at least five concise records across issues, tests, releases and design notes.",
        penalty=5,
      ),
    )
  } else {
    findings.push(
      maintenance_fail(
        "trace.volume",
        "No development evidence records were supplied",
        "0 records",
        "Add issue, test, changelog, release and design records before review.",
        penalty=16,
      ),
    )
  }
}

///|
fn push_kind_minimum_finding(
  findings : Array[MaintenanceFinding],
  records : Array[MaintenanceRecord],
  kind : MaintenanceRecordKind,
  minimum : Int,
  id : String,
  title : String,
  repair : String,
) -> Unit {
  let count = count_records_by_kind(records, kind)
  if count >= minimum {
    findings.push(maintenance_pass(id, title, count.to_string() + " records"))
  } else {
    findings.push(
      maintenance_fail(
        id,
        title + " are missing",
        count.to_string() + "/" + minimum.to_string(),
        repair,
        penalty=12,
      ),
    )
  }
}

///|
fn push_required_kind_finding(
  findings : Array[MaintenanceFinding],
  records : Array[MaintenanceRecord],
  kind : MaintenanceRecordKind,
  required : Bool,
  id : String,
  title : String,
  repair : String,
) -> Unit {
  if !required {
    findings.push(maintenance_pass(id, title, "not required by policy"))
    return
  }
  let count = count_records_by_kind(records, kind)
  if count > 0 {
    findings.push(maintenance_pass(id, title, count.to_string() + " records"))
  } else {
    findings.push(
      maintenance_fail(id, title + " missing", "0 records", repair, penalty=10),
    )
  }
}

///|
fn push_done_evidence_finding(
  findings : Array[MaintenanceFinding],
  records : Array[MaintenanceRecord],
) -> Unit {
  let mut missing = 0
  for record in records {
    if record.state == Done && !record_has_evidence(record) {
      missing += 1
    }
  }
  if missing == 0 {
    findings.push(
      maintenance_pass(
        "trace.done-evidence", "Completed records have evidence", "all completed records are backed by evidence",
      ),
    )
  } else {
    findings.push(
      maintenance_warn(
        "trace.done-evidence",
        "Some completed records lack evidence",
        missing.to_string() + " completed records",
        "Attach a file path, release link or concise evidence string to completed records.",
        penalty=missing * 3,
      ),
    )
  }
}

///|
fn push_open_work_finding(
  findings : Array[MaintenanceFinding],
  records : Array[MaintenanceRecord],
) -> Unit {
  let mut blocked = 0
  let mut open = 0
  for record in records {
    if record.state == BlockedState {
      blocked += 1
    } else if record.state == Planned ||
      record.state == InProgress ||
      record.state == Deferred {
      open += 1
    }
  }
  if blocked > 0 {
    findings.push(
      maintenance_fail(
        "trace.blocked-work",
        "Blocked maintenance records remain",
        blocked.to_string() + " blocked records",
        "Resolve or explicitly defer blocked review work before final acceptance.",
        penalty=14,
      ),
    )
  } else if open > 0 {
    findings.push(
      maintenance_warn(
        "trace.open-work",
        "Open maintenance records remain",
        open.to_string() + " open records",
        "Make sure open records describe follow-up work, not unfinished promised scope.",
        penalty=4,
      ),
    )
  } else {
    findings.push(
      maintenance_pass(
        "trace.closed-work", "No blocked maintenance records remain", "all records are completed",
      ),
    )
  }
}

///|
fn count_records_by_kind(
  records : Array[MaintenanceRecord],
  kind : MaintenanceRecordKind,
) -> Int {
  let mut total = 0
  for record in records {
    if record.kind == kind {
      total += 1
    }
  }
  total
}

///|
fn count_records_by_state(
  records : Array[MaintenanceRecord],
  state : MaintenanceState,
) -> Int {
  let mut total = 0
  for record in records {
    if record.state == state {
      total += 1
    }
  }
  total
}

///|
fn count_records_with_evidence(records : Array[MaintenanceRecord]) -> Int {
  let mut total = 0
  for record in records {
    if record_has_evidence(record) {
      total += 1
    }
  }
  total
}

///|
fn record_has_evidence(record : MaintenanceRecord) -> Bool {
  has_text(record.evidence) || has_text(record.link) || has_text(record.note)
}

///|
fn maintenance_score(findings : Array[MaintenanceFinding]) -> Int {
  let mut score = 100
  for finding in findings {
    score -= finding.penalty
  }
  if score < 0 {
    0
  } else {
    score
  }
}

///|
fn maintenance_verdict(
  findings : Array[MaintenanceFinding],
  score : Int,
) -> String {
  let mut fail_count = 0
  let mut warn_count = 0
  for finding in findings {
    if finding.severity == Fail {
      fail_count += 1
    } else if finding.severity == Warn {
      warn_count += 1
    }
  }
  if fail_count > 0 {
    "trace-blocked"
  } else if score >= 95 && warn_count == 0 {
    "trace-ready"
  } else if score >= 80 {
    "trace-ready-with-notes"
  } else {
    "trace-needs-work"
  }
}

///|
fn maintenance_pass(
  id : String,
  title : String,
  evidence : String,
) -> MaintenanceFinding {
  {
    id,
    severity: Pass,
    title,
    detail: "Requirement satisfied.",
    repair: "",
    evidence,
    penalty: 0,
  }
}

///|
fn maintenance_warn(
  id : String,
  title : String,
  detail : String,
  repair : String,
  penalty? : Int = 4,
) -> MaintenanceFinding {
  { id, severity: Warn, title, detail, repair, evidence: detail, penalty }
}

///|
fn maintenance_fail(
  id : String,
  title : String,
  detail : String,
  repair : String,
  penalty? : Int = 10,
) -> MaintenanceFinding {
  { id, severity: Fail, title, detail, repair, evidence: detail, penalty }
}

///|
fn maintenance_kind_text(kind : MaintenanceRecordKind) -> String {
  match kind {
    IssueRecord => "issue"
    PullRequestRecord => "pull-request"
    TestRecord => "test"
    ChangelogEntry => "changelog"
    ReleaseRecord => "release"
    DesignDecision => "design"
    LicenseNote => "license"
    CiRunRecord => "ci"
  }
}

///|
fn maintenance_state_text(state : MaintenanceState) -> String {
  match state {
    Planned => "planned"
    InProgress => "in-progress"
    Done => "done"
    Deferred => "deferred"
    BlockedState => "blocked"
  }
}
