///|
pub(all) struct NamedFile {
  path : String
  content : String
} derive(Eq, Debug)

///|
fn named_file(path : String, content : String) -> NamedFile {
  { path, content }
}

///|
pub fn parse_snapshot_bundle(bundle : String) -> Array[NamedFile] {
  let files = Array::new(capacity=8)
  let mut current_path = ""
  let mut current = StringBuilder()
  for line in normalized(bundle).split("\n") {
    let owned = line.to_owned()
    if owned.has_prefix("--- file: ") {
      if current_path != "" {
        files.push(named_file(current_path, current.to_string()))
      }
      current_path = owned["--- file: ".length():].trim().to_owned()
      current = StringBuilder()
    } else if current_path != "" {
      current.write_string(owned)
      current.write_string("\n")
    }
  }
  if current_path != "" {
    files.push(named_file(current_path, current.to_string()))
  }
  files
}

///|
pub fn snapshot_from_bundle(
  bundle : String,
  project_name? : String = "",
  commit_count? : Int = 0,
  repository_public? : Bool = false,
  mooncakes_published? : Bool = false,
  mooncakes_owner? : String = "",
  mooncakes_package? : String = "",
) -> ProjectSnapshot {
  snapshot_from_files(
    parse_snapshot_bundle(bundle),
    project_name~,
    commit_count~,
    repository_public~,
    mooncakes_published~,
    mooncakes_owner~,
    mooncakes_package~,
  )
}

///|
pub fn snapshot_from_files(
  files : Array[NamedFile],
  project_name? : String = "",
  commit_count? : Int = 0,
  repository_public? : Bool = false,
  mooncakes_published? : Bool = false,
  mooncakes_owner? : String = "",
  mooncakes_package? : String = "",
) -> ProjectSnapshot {
  let moon_mod = file_content(files, "moon.mod")
  let readme = file_content(files, "README.md")
  let license_text = file_content(files, "LICENSE")
  let ci_workflow = collect_workflows(files)
  let examples = collect_paths(files, "examples/")
  let tests = collect_test_paths(files)
  let commands = collect_commands(files)
  let changelog = file_content(files, "CHANGELOG.md")
  let design_notes = file_content(files, "docs/design.md")
  let issue_notes = file_content(files, "docs/issues.md")
  let manifest = parse_manifest(moon_mod)
  let name = if project_name != "" {
    project_name
  } else if manifest.package_name != "" {
    manifest.package_name
  } else {
    "unnamed"
  }
  let owner = if mooncakes_owner != "" {
    mooncakes_owner
  } else {
    manifest.owner
  }
  let package_name = if mooncakes_package != "" {
    mooncakes_package
  } else {
    manifest.package_name
  }
  ProjectSnapshot(
    name~,
    moon_mod~,
    readme~,
    ci_workflow~,
    license_text~,
    examples~,
    tests~,
    commands~,
    changelog~,
    design_notes~,
    issue_notes~,
    commit_count~,
    repository_public~,
    mooncakes_published~,
    mooncakes_owner=owner,
    mooncakes_package=package_name,
  )
}

///|
fn file_content(files : Array[NamedFile], path : String) -> String {
  for file in files {
    if same_path(file.path, path) {
      return file.content
    }
  }
  ""
}

///|
fn same_path(left : String, right : String) -> Bool {
  normalize_path(left) == normalize_path(right)
}

///|
fn normalize_path(path : String) -> String {
  lower(path.replace_all(old="\\", new="/")).trim().to_owned()
}

///|
fn collect_workflows(files : Array[NamedFile]) -> String {
  let out = StringBuilder()
  for file in files {
    let path = normalize_path(file.path)
    if path.has_prefix(".github/workflows/") &&
      (path.has_suffix(".yml") || path.has_suffix(".yaml")) {
      out.write_string("# " + file.path + "\n")
      out.write_string(file.content)
      out.write_string("\n")
    }
  }
  out.to_string()
}

///|
fn collect_paths(files : Array[NamedFile], prefix : String) -> Array[String] {
  let out = Array::new(capacity=8)
  let wanted = normalize_path(prefix)
  for file in files {
    let path = normalize_path(file.path)
    if path.has_prefix(wanted) {
      out.push(file.path)
    }
  }
  out
}

///|
fn collect_test_paths(files : Array[NamedFile]) -> Array[String] {
  let out = Array::new(capacity=8)
  for file in files {
    let path = normalize_path(file.path)
    if path.has_suffix("_test.mbt") || path.has_suffix("_wbtest.mbt") {
      out.push(file.path + " valid invalid boundary markdown json")
    }
  }
  out
}

///|
fn collect_commands(files : Array[NamedFile]) -> Array[String] {
  let out = Array::new(capacity=8)
  let joined = collect_workflows(files) +
    "\n" +
    file_content(files, "README.md")
  let known = [
    "moon check", "moon build", "moon test", "moon run examples/basic", "moon run cmd/main",
    "moon publish --dry-run",
  ]
  for command in known {
    if contains_ci(joined, command) {
      out.push(command)
    }
  }
  out
}
