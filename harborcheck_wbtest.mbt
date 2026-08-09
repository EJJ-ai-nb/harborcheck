///|
test "manifest_value strips quotes and whitespace" {
  let text =
    #|name = "owner/pkg"
    #|version = "0.1.0"
    #|license = "MIT"
    #|
  @test.assert_eq(manifest_value(text, "name"), "owner/pkg")
  @test.assert_eq(manifest_value(text, "version"), "0.1.0")
  @test.assert_eq(manifest_value(text, "missing"), "")
}

///|
test "semver_like accepts exact three numeric components" {
  @test.assert_eq(semver_like("0.1.0"), true)
  @test.assert_eq(semver_like("12.30.400"), true)
  @test.assert_eq(semver_like("0.1"), false)
  @test.assert_eq(semver_like("0.1.x"), false)
  @test.assert_eq(semver_like(""), false)
}

///|
test "valid_slug accepts Mooncakes-safe owner and package names" {
  @test.assert_eq(valid_slug("WVYT-ai-nb"), true)
  @test.assert_eq(valid_slug("harborcheck"), true)
  @test.assert_eq(valid_slug("pkg_1"), true)
  @test.assert_eq(valid_slug("bad/name"), false)
  @test.assert_eq(valid_slug(""), false)
}

///|
test "parse_digits rejects non numeric input" {
  debug_inspect(parse_digits("42"), content="Some(42)")
  debug_inspect(parse_digits(" 007 "), content="Some(7)")
  debug_inspect(parse_digits("4x"), content="None")
  debug_inspect(parse_digits(""), content="None")
}

///|
test "json_escape protects quotes slashes and newlines" {
  @test.assert_eq(json_escape("a\"b"), "a\\\"b")
  @test.assert_eq(json_escape("a\\b"), "a\\\\b")
  @test.assert_eq(json_escape("a\nb"), "a\\nb")
}

///|
test "score is clamped to zero for catastrophic snapshots" {
  let findings = [
    fail("a", Readme, "a", "a", "a", "a", penalty=70),
    fail("b", Tests, "b", "b", "b", "b", penalty=70),
  ]
  @test.assert_eq(score_findings(findings), 0)
}

///|
test "verdict requires no failures for ready" {
  @test.assert_eq(verdict_for(100, 0), "ready")
  @test.assert_eq(verdict_for(82, 1), "almost-ready")
  @test.assert_eq(verdict_for(82, 3), "needs-work")
}
