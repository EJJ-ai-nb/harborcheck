///|
fn main {
  let report = @harborcheck.audit(@harborcheck.example_snapshot())
  println(report.to_markdown())
  let identity = @harborcheck.SubmissionIdentity(
    applicant_name="张雨晴",
    phone="18055754016",
    email="2327797191@qq.com",
    github_owner="EJJ-ai-nb",
    repository_name="harborcheck",
    mooncakes_owner="EJJ-ai-nb",
    package_name="harborcheck",
  )
  let submission =
    #|张雨晴
    #|18055754016
    #|2327797191@qq.com
    #|https://github.com/EJJ-ai-nb/harborcheck
    #|EJJ-ai-nb/harborcheck
    #|
  println(
    @harborcheck.acceptance_identity_markdown(
      identity,
      @harborcheck.example_snapshot(),
      submission,
      git_user_name="EJJ-ai-nb",
      git_user_email="2327797191@qq.com",
      git_remote="https://github.com/EJJ-ai-nb/harborcheck.git",
    ),
  )
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
  let final_review = @harborcheck.final_acceptance_review(
    @harborcheck.example_snapshot(),
    identity,
    submission,
    markdown,
    [
      @harborcheck.SourceEvidence(
        name="HarborCheck source",
        kind=@harborcheck.OwnedCode,
        license="MIT",
        note="Original MoonBit implementation by the project applicant",
      ),
    ],
    profile=@harborcheck.AcceptanceProfile(
      effective_moonbit_loc=3631,
      target_moonbit_loc=4000,
      ci_status="success",
      mooncakes_build_status="success",
      latest_commit_author="张雨晴",
      latest_commit_email="2327797191@qq.com",
      contest_commit_count=12,
      published_version="0.1.3",
    ),
    git_user_name="EJJ-ai-nb",
    git_user_email="2327797191@qq.com",
    git_remote="https://github.com/EJJ-ai-nb/harborcheck.git",
  )
  println(final_review.to_markdown())
}
