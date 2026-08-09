///|
fn main {
  let report = @harborcheck.audit(@harborcheck.example_snapshot())
  println(
    "HarborCheck " + report.verdict + " " + report.score.to_string() + "/100",
  )
  println("package=" + report.package_name)
}
