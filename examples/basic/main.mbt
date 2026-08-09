fn main {
  let report = @harborcheck.audit(@harborcheck.example_snapshot())
  println(report.to_markdown())
}
