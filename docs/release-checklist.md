# Release Checklist

- Confirm GitHub repository is public: `https://github.com/EJJ-ai-nb/harborcheck`.
- Confirm `moon.mod` has `name = "EJJ-ai-nb/harborcheck"`.
- Confirm `moon.mod` has `repository = "https://github.com/EJJ-ai-nb/harborcheck.git"`.
- Confirm README title and submission document describe the project as README example verification and provenance proof.
- Confirm no other applicant name, account, email or unrelated project identity appears in repository files.
- Run `moon check`.
- Run `moon build`.
- Run `moon test`.
- Run `moon fmt --check`.
- Run `moon run examples/basic`.
- Run `moon run cmd/main`.
- Run `moon publish --dry-run`.
- Run `moon publish`.
- Confirm `https://mooncakes.io/docs/EJJ-ai-nb/harborcheck`.
- Confirm `https://mooncakes.io/api/v0/manifest/EJJ-ai-nb/harborcheck`.
