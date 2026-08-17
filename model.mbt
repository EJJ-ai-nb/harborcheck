///|
pub(all) enum Severity {
  Pass
  Warn
  Fail
} derive(Eq, Debug)

///|
pub(all) enum CheckKind {
  PackageConfig
  Readme
  ContinuousIntegration
  Tests
  Examples
  Build
  Mooncakes
  GitTrace
  License
  Boundary
  DocProof
} derive(Eq, Debug)

///|
pub(all) struct ProjectSnapshot {
  name : String
  moon_mod : String
  readme : String
  ci_workflow : String
  license_text : String
  examples : Array[String]
  tests : Array[String]
  commands : Array[String]
  changelog : String
  design_notes : String
  issue_notes : String
  commit_count : Int
  repository_public : Bool
  mooncakes_published : Bool
  mooncakes_owner : String
  mooncakes_package : String
} derive(Eq, Debug)

///|
pub fn ProjectSnapshot::ProjectSnapshot(
  name? : String = "",
  moon_mod? : String = "",
  readme? : String = "",
  ci_workflow? : String = "",
  license_text? : String = "",
  examples? : Array[String] = [],
  tests? : Array[String] = [],
  commands? : Array[String] = [],
  changelog? : String = "",
  design_notes? : String = "",
  issue_notes? : String = "",
  commit_count? : Int = 0,
  repository_public? : Bool = false,
  mooncakes_published? : Bool = false,
  mooncakes_owner? : String = "",
  mooncakes_package? : String = "",
) -> ProjectSnapshot {
  {
    name,
    moon_mod,
    readme,
    ci_workflow,
    license_text,
    examples,
    tests,
    commands,
    changelog,
    design_notes,
    issue_notes,
    commit_count,
    repository_public,
    mooncakes_published,
    mooncakes_owner,
    mooncakes_package,
  }
}

///|
pub(all) struct PackageManifest {
  module_name : String
  version : String
  readme : String
  repository : String
  license : String
  description : String
  owner : String
  package_name : String
  has_valid_name : Bool
  has_semver : Bool
} derive(Eq, Debug)

///|
pub(all) struct Finding {
  id : String
  kind : CheckKind
  severity : Severity
  title : String
  detail : String
  repair : String
  evidence : String
  penalty : Int
} derive(Eq, Debug)

///|
pub(all) struct AuditMetrics {
  pass_count : Int
  warn_count : Int
  fail_count : Int
  command_count : Int
  test_fixture_count : Int
  example_count : Int
} derive(Eq, Debug)

///|
pub(all) struct AuditReport {
  project_name : String
  score : Int
  max_score : Int
  verdict : String
  package_name : String
  repository : String
  findings : Array[Finding]
  metrics : AuditMetrics
} derive(Eq, Debug)

///|
fn finding(
  id : String,
  kind : CheckKind,
  severity : Severity,
  title : String,
  detail : String,
  repair : String,
  evidence : String,
  penalty : Int,
) -> Finding {
  { id, kind, severity, title, detail, repair, evidence, penalty }
}

///|
fn pass(
  id : String,
  kind : CheckKind,
  title : String,
  evidence : String,
) -> Finding {
  finding(id, kind, Pass, title, "Requirement satisfied.", "", evidence, 0)
}

///|
fn warn(
  id : String,
  kind : CheckKind,
  title : String,
  detail : String,
  repair : String,
  evidence : String,
  penalty? : Int = 3,
) -> Finding {
  finding(id, kind, Warn, title, detail, repair, evidence, penalty)
}

///|
fn fail(
  id : String,
  kind : CheckKind,
  title : String,
  detail : String,
  repair : String,
  evidence : String,
  penalty? : Int = 10,
) -> Finding {
  finding(id, kind, Fail, title, detail, repair, evidence, penalty)
}
