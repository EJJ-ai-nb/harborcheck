///|
test "valid snapshot is ready" {
  let report = @harborcheck.audit(@harborcheck.example_snapshot())
  @test.assert_eq(report.verdict, "ready")
  @test.assert_eq(report.score, 100)
  @test.assert_eq(report.metrics.fail_count, 0)
  assert_true(report.metrics.pass_count > 20)
}

///|
test "invalid snapshot reports hard failures" {
  let snapshot = @harborcheck.ProjectSnapshot(
    name="BrokenPackage",
    moon_mod=(
      #|name = "broken"
      #|version = "draft"
      #|readme = "README.mbt.md"
      #|repository = ""
      #|license = "Unknown"
      #|description = ""
      #|
    ),
    readme="",
    ci_workflow="",
    license_text="",
    tests=[],
    examples=[],
    commands=["moon check"],
    repository_public=false,
    mooncakes_published=false,
  )
  let report = @harborcheck.audit(snapshot)
  @test.assert_eq(report.verdict, "needs-work")
  assert_true(report.score < 50)
  assert_true(report.metrics.fail_count >= 8)
}

///|
test "partial snapshot is almost ready but not publishable" {
  let base = @harborcheck.example_snapshot()
  let snapshot = @harborcheck.ProjectSnapshot(
    name=base.name,
    moon_mod=base.moon_mod,
    readme=base.readme,
    ci_workflow=base.ci_workflow,
    license_text=base.license_text,
    examples=base.examples,
    tests=base.tests,
    commands=base.commands,
    changelog=base.changelog,
    design_notes=base.design_notes,
    issue_notes=base.issue_notes,
    commit_count=5,
    repository_public=true,
    mooncakes_published=false,
    mooncakes_owner="WVYT-ai-nb",
    mooncakes_package="harborcheck",
  )
  let report = @harborcheck.audit(snapshot)
  @test.assert_eq(report.verdict, "almost-ready")
  @test.assert_eq(report.metrics.fail_count, 1)
  assert_true(report.score >= 75)
}

///|
test "manifest parser exposes Mooncakes identity" {
  let manifest_text =
    #|name = "WVYT-ai-nb/harborcheck"
    #|version = "0.1.0"
    #|readme = "README.md"
    #|repository = "https://github.com/WVYT-ai-nb/harborcheck.git"
    #|license = "MIT"
    #|description = "MoonBit-native release readiness auditor"
    #|
  let manifest = @harborcheck.parse_manifest(manifest_text)
  @test.assert_eq(manifest.owner, "WVYT-ai-nb")
  @test.assert_eq(manifest.package_name, "harborcheck")
  @test.assert_eq(manifest.has_semver, true)
  @test.assert_eq(manifest.has_valid_name, true)
}

///|
test "markdown export includes score and actionable findings" {
  let report = @harborcheck.audit(@harborcheck.example_snapshot())
  let markdown = report.to_markdown()
  assert_true(markdown.contains("# HarborCheck Audit"))
  assert_true(markdown.contains("- Score: 100/100"))
  assert_true(markdown.contains("moon.mod.name"))
  assert_true(markdown.contains("ci.test"))
}

///|
test "json export is compact and machine readable" {
  let report = @harborcheck.audit(@harborcheck.example_snapshot())
  let json = report.to_json()
  assert_true(json.has_prefix("{"))
  assert_true(json.has_suffix("}"))
  assert_true(json.contains("\"score\":100"))
  assert_true(json.contains("\"verdict\":\"ready\""))
  assert_true(json.contains("\"findings\""))
}

///|
test "top level helpers delegate to audit report exporters" {
  let snapshot = @harborcheck.example_snapshot()
  assert_true(
    @harborcheck.audit_markdown(snapshot).contains("HarborCheck Audit"),
  )
  assert_true(
    @harborcheck.audit_json(snapshot).contains("\"project\":\"HarborCheck\""),
  )
}

///|
test "repair checklist is empty for ready snapshot" {
  let report = @harborcheck.audit(@harborcheck.example_snapshot())
  @test.assert_eq(report.has_blockers(), false)
  @test.assert_eq(report.repair_steps().length(), 0)
  assert_true(report.to_release_checklist().contains("All checks pass"))
}

///|
test "repair checklist lists blocking actions for broken snapshot" {
  let snapshot = @harborcheck.ProjectSnapshot(
    name="BrokenPackage",
    moon_mod="",
    readme="",
    ci_workflow="",
    license_text="",
    repository_public=false,
    mooncakes_published=false,
  )
  let report = @harborcheck.audit(snapshot)
  @test.assert_eq(report.has_blockers(), true)
  assert_true(report.repair_steps().length() >= 8)
  assert_true(@harborcheck.release_checklist(snapshot).contains("[blocking]"))
}

///|
test "rule catalog exposes every audit rule" {
  @test.assert_eq(@harborcheck.catalog_size(), 34)
  let readme_rules = @harborcheck.rules_for_kind(@harborcheck.Readme)
  assert_true(readme_rules.length() >= 8)
  debug_inspect(
    @harborcheck.find_rule("ci.test").map(rule => rule.title),
    content="Some(\"Runs moon test\")",
  )
  assert_true(@harborcheck.rules_markdown().contains("moon.mod.name"))
}

///|
test "snapshot bundle parser builds an auditable snapshot" {
  let bundle =
    #|--- file: moon.mod
    #|name = "WVYT-ai-nb/harborcheck"
    #|version = "0.1.0"
    #|readme = "README.md"
    #|repository = "https://github.com/WVYT-ai-nb/harborcheck.git"
    #|license = "MIT"
    #|description = "MoonBit-native release readiness auditor for Mooncakes packages"
    #|--- file: README.md
    #|# HarborCheck
    #|解决 MoonBit package release review problem.
    #|安装 moon add WVYT-ai-nb/harborcheck.
    #|使用 moon run examples/basic.
    #|API audit.
    #|支持范围 package audit.
    #|暂不支持 publishing.
    #|moon check
    #|moon build
    #|moon test
    #|MIT License third-party none.
    #|--- file: .github/workflows/ci.yml
    #|curl -fsSL https://cli.moonbitlang.com/install/unix.sh | bash
    #|moon check
    #|moon build
    #|moon test
    #|moon run examples/basic
    #|--- file: LICENSE
    #|MIT License
    #|--- file: harborcheck_test.mbt
    #|valid invalid boundary markdown json
    #|--- file: examples/basic/main.mbt
    #|fn main { println("ok") }
    #|--- file: CHANGELOG.md
    #|0.1.0
    #|--- file: docs/design.md
    #|Design boundary.
    #|--- file: docs/issues.md
    #|Issue record.
    #|
  let snapshot = @harborcheck.snapshot_from_bundle(
    bundle,
    project_name="HarborCheck",
    commit_count=6,
    repository_public=true,
    mooncakes_published=true,
  )
  let report = @harborcheck.audit(snapshot)
  @test.assert_eq(report.verdict, "ready")
  @test.assert_eq(report.metrics.example_count, 1)
  assert_true(report.metrics.command_count >= 4)
}
