///|
fn main {
  let report = @harborcheck.audit(@harborcheck.example_snapshot())
  println(report.to_markdown())
  let markdown =
    #|# Usage
    #|
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
  println(proof.to_markdown())
}
