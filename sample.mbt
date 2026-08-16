///|
pub fn harborcheck_example_snapshot() -> ProjectSnapshot {
  ProjectSnapshot(
    name="HarborCheck",
    moon_mod=(
      #|name = "EJJ-ai-nb/harborcheck"
      #|version = "0.1.0"
      #|readme = "README.md"
      #|repository = "https://github.com/EJJ-ai-nb/harborcheck.git"
      #|license = "MIT"
      #|description = "MoonBit-native release readiness auditor for Mooncakes packages"
      #|
    ),
    readme=(
      #|# HarborCheck
      #|
      #|HarborCheck solves the problem of checking MoonBit package release readiness before submitting to Mooncakes.
      #|
      #|## Installation
      #|
      #|moon add EJJ-ai-nb/harborcheck
      #|
      #|## Usage
      #|
      #|Run the example with moon run examples/basic.
      #|
      #|## API
      #|
      #|audit, audit_markdown, audit_json and parse_manifest are the core APIs.
      #|
      #|## Supported scope
      #|
      #|README, CI, package metadata, tests, examples, license and release trace checks.
      #|
      #|## Out of scope
      #|
      #|It does not push to GitHub or publish to Mooncakes by itself.
      #|
      #|## Verification
      #|
      #|moon check
      #|moon build
      #|moon test
      #|
      #|## License
      #|
      #|MIT License. No third-party code or assets are bundled.
      #|
    ),
    ci_workflow=(
      #|name: ci
      #|on: [push, pull_request]
      #|jobs:
      #|  test:
      #|    runs-on: ubuntu-latest
      #|    steps:
      #|      - uses: actions/checkout@v4
      #|      - run: curl -fsSL https://cli.moonbitlang.com/install/unix.sh | bash
      #|      - run: moon check
      #|      - run: moon build
      #|      - run: moon test
      #|      - run: moon run examples/basic
      #|      - run: moon run cmd/main
      #|
    ),
    license_text=(
      #|MIT License
      #|
      #|Copyright (c) 2026 HarborCheck contributors
      #|
      #|Permission is hereby granted, free of charge, to any person obtaining a copy
      #|of this software and associated documentation files.
      #|
    ),
    examples=["valid example: moon run examples/basic"],
    tests=[
      "valid snapshot should pass package/readme/ci checks", "invalid snapshot should fail missing README and CI",
      "boundary empty snapshot should keep score in range", "markdown export should include findings",
      "json export should include score and verdict",
    ],
    commands=[
      "moon check", "moon build", "moon test", "moon run examples/basic", "moon run cmd/main",
      "moon publish --dry-run",
    ],
    changelog="# Changelog\n\n## 0.1.0\n\nInitial public release.",
    design_notes="# Design\n\nPure MoonBit audit rules over a project snapshot.",
    issue_notes="# Issues\n\n- Track Mooncakes release readiness.\n- Keep CI smoke tests reproducible.",
    commit_count=10,
    repository_public=true,
    mooncakes_published=true,
    mooncakes_owner="EJJ-ai-nb",
    mooncakes_package="harborcheck",
  )
}
