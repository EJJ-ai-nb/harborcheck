///|
pub fn harborcheck_example_snapshot() -> ProjectSnapshot {
  ProjectSnapshot(
    name="HarborCheck",
    moon_mod=(
      #|name = "EJJ-ai-nb/harborcheck"
      #|version = "0.1.4"
      #|readme = "README.md"
      #|repository = "https://github.com/EJJ-ai-nb/harborcheck.git"
      #|license = "MIT"
      #|description = "MoonBit-native README example verifier and open-source provenance proof toolkit"
      #|
    ),
    readme=(
      #|# HarborCheck
      #|
      #|HarborCheck solves the documentation reproducibility problem by verifying README examples and open-source provenance evidence before a MoonBit package is submitted.
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
      #|doc_proof, extract_doc_snippets, audit, audit_markdown and audit_json are the core APIs.
      #|
      #|## Supported scope
      #|
      #|README examples, source provenance, package metadata, CI, tests, license and release trace checks.
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
      #|      - run: moon check --deny-warn
      #|      - run: moon build
      #|      - run: moon fmt --check
      #|      - run: moon test --deny-warn
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
      "valid snapshot should pass package/readme/ci checks", "doc proof should verify runnable examples",
      "invalid provenance should fail source proof", "boundary empty snapshot should keep score in range",
      "markdown export should include findings", "json export should include score and verdict",
    ],
    commands=[
      "moon check", "moon build", "moon test", "moon run examples/basic", "moon run cmd/main",
      "moon publish --dry-run",
    ],
    changelog="# Changelog\n\n## 0.1.4\n\nAdded maintenance evidence review.\n\n## 0.1.3\n\nAdded identity proof and final acceptance review.",
    design_notes="# Design\n\nPure MoonBit doc-proof and audit rules over a project snapshot.",
    issue_notes="# Issues\n\n- Verify README snippets.\n- Track source provenance.\n- Keep CI smoke tests reproducible.",
    commit_count=10,
    repository_public=true,
    mooncakes_published=true,
    mooncakes_owner="EJJ-ai-nb",
    mooncakes_package="harborcheck",
  )
}
