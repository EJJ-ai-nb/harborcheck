///|
fn manifest_value(moon_mod : String, key : String) -> String {
  let prefix = key + " ="
  for raw in normalized(moon_mod).split("\n") {
    let line = raw.trim().to_owned()
    if line.has_prefix(prefix) {
      let tail = line[prefix.length():].to_owned()
      return strip_quotes(tail)
    }
  }
  ""
}

///|
pub fn parse_manifest(moon_mod : String) -> PackageManifest {
  let module_name = manifest_value(moon_mod, "name")
  let version = manifest_value(moon_mod, "version")
  let readme = manifest_value(moon_mod, "readme")
  let repository = manifest_value(moon_mod, "repository")
  let license = manifest_value(moon_mod, "license")
  let description = manifest_value(moon_mod, "description")
  let owner = owner_part(module_name)
  let package_name = package_part(module_name)
  {
    module_name,
    version,
    readme,
    repository,
    license,
    description,
    owner,
    package_name,
    has_valid_name: valid_slug(owner) && valid_slug(package_name),
    has_semver: semver_like(version),
  }
}

///|
fn known_osi_license(license : String) -> Bool {
  license == "MIT" ||
  license == "Apache-2.0" ||
  license == "BSD-2-Clause" ||
  license == "BSD-3-Clause" ||
  license == "MPL-2.0" ||
  license == "ISC"
}
