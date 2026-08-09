# Release Checklist

- Confirm GitHub repository is public: `https://github.com/WVYT-ai-nb/harborcheck`.
- Confirm `moon.mod` has `name = "WVYT-ai-nb/harborcheck"`.
- Confirm `moon.mod` has `repository = "https://github.com/WVYT-ai-nb/harborcheck.git"`.
- Run `moon check`.
- Run `moon build`.
- Run `moon test`.
- Run `moon run examples/basic`.
- Run `moon run cmd/main`.
- Run `moon publish --dry-run`.
- Run `moon publish`.
- Confirm `https://mooncakes.io/docs/WVYT-ai-nb/harborcheck`.
- Confirm `https://mooncakes.io/api/v0/manifest/WVYT-ai-nb/harborcheck`.
