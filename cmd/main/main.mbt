///|
fn main {
  let report = @harborcheck.audit(@harborcheck.example_snapshot())
  let markdown =
    #|```moonbit
    #|fn main {
    #|  println("verified")
    #|}
    #|```
    #|
  let proof = @harborcheck.doc_proof(markdown, [
    @harborcheck.SourceEvidence(
      name="HarborCheck source",
      kind=@harborcheck.OwnedCode,
      license="MIT",
      note="Original MoonBit implementation by the project applicant",
    ),
  ])
  println(
    "HarborCheck " + report.verdict + " " + report.score.to_string() + "/100",
  )
  println("package=" + report.package_name)
  println("doc-proof=" + proof.verdict)
}
