///|
fn normalized(text : String) -> String {
  text.replace_all(old="\r\n", new="\n").replace_all(old="\r", new="\n")
}

///|
fn lower(text : String) -> String {
  text.to_lower()
}

///|
fn has_text(text : String) -> Bool {
  !text.trim().is_empty()
}

///|
fn contains_ci(text : String, needle : String) -> Bool {
  lower(text).contains(lower(needle))
}

///|
fn contains_any(text : String, needles : Array[String]) -> Bool {
  for needle in needles {
    if contains_ci(text, needle) {
      return true
    }
  }
  false
}

///|
fn count_contains(texts : Array[String], needle : String) -> Int {
  let mut total = 0
  for text in texts {
    if contains_ci(text, needle) {
      total += 1
    }
  }
  total
}

///|
fn strip_quotes(value : String) -> String {
  let trimmed = value.trim().to_owned()
  if trimmed.length() >= 2 &&
    trimmed.has_prefix("\"") &&
    trimmed.has_suffix("\"") {
    trimmed[1:trimmed.length() - 1].to_owned()
  } else {
    trimmed
  }
}

///|
fn json_escape(text : String) -> String {
  text
  .replace_all(old="\\", new="\\\\")
  .replace_all(old="\"", new="\\\"")
  .replace_all(old="\n", new="\\n")
}

///|
fn parse_digits(text : String) -> Int? {
  let trimmed = text.trim().to_owned()
  if trimmed.is_empty() {
    return None
  }
  let mut value = 0
  for ch in trimmed {
    let code = ch.to_int()
    if code < 48 || code > 57 {
      return None
    }
    value = value * 10 + code - 48
  }
  Some(value)
}

///|
fn semver_like(version : String) -> Bool {
  let parts = version.split(".").to_array()
  if parts.length() != 3 {
    return false
  }
  parse_digits(parts[0].to_owned()) is Some(_) &&
  parse_digits(parts[1].to_owned()) is Some(_) &&
  parse_digits(parts[2].to_owned()) is Some(_)
}

///|
fn owner_part(module_name : String) -> String {
  let parts = module_name.split("/").to_array()
  if parts.length() == 2 { parts[0].to_owned() } else { "" }
}

///|
fn package_part(module_name : String) -> String {
  let parts = module_name.split("/").to_array()
  if parts.length() == 2 { parts[1].to_owned() } else { module_name }
}

///|
fn valid_slug(text : String) -> Bool {
  if text.is_empty() {
    return false
  }
  for ch in text {
    let code = ch.to_int()
    let digit = code >= 48 && code <= 57
    let upper = code >= 65 && code <= 90
    let lower_alpha = code >= 97 && code <= 122
    let dash = code == 45 || code == 95
    if !(digit || upper || lower_alpha || dash) {
      return false
    }
  }
  true
}
