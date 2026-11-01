# Contributing to molo (iOS app)

Thank you for your interest in improving molo! Contributions of all kinds are
welcome: bug reports, documentation, translations and code.

## Reporting bugs and proposing features

Please open an issue and describe

- what you expected and what happened instead,
- steps to reproduce, including device, iOS version and app version
  (never include secrets or personal data),
- the commit or release you tested.

Please report security issues privately to [kontakt@molo.news](mailto:kontakt@molo.news)
or via GitHub's private vulnerability reporting instead of opening an issue.

## Development setup

Follow the *Getting started* section in [README.md](README.md). You need a
Firebase project of your own for push notifications; the app does not build
without a `GoogleService-Info.plist` (see the `.example` template). Everything
else works against any instance of the
[molo backend](https://github.com/zemki/molonews-django-backend).

## Pull requests

1. Fork the repository and create a branch from `main`.
2. Keep changes focused; one topic per pull request.
3. Make sure the workspace builds and the app runs in the simulator before you push.
4. If you change the backend contract, regenerate the API client from
   `moloCore/DataLayer/MoloAPIClient/openapi.yaml` instead of editing generated code.
5. Describe what changed and why in the pull request.

## Guidelines

- **No secrets, personal data or instance-specific values in the code.** Firebase
  configuration belongs in the git-ignored `GoogleService-Info.plist`; the backend
  URL is the `servers` entry in `moloCore/DataLayer/MoloAPIClient/openapi.yaml`
  (see README, *Point the app at your own backend*). Do not commit
  provisioning profiles, certificates, API keys or test accounts.
- **Generic over specific.** Code for a single city, source or customer belongs in
  configuration or in the backend, not in the app.
- Keep the module boundaries (`moloCore` → `moloUI` → `moloFeatures` → `moloApp`):
  domain and data code has no UI dependencies, features do not depend on each other.
- Code comments may be German or English; keep them consistent within a file.
  User-facing texts live in `moloResources` (`Localizable.strings`).

## License

By contributing, you agree that your contributions are licensed under the
[AGPL-3.0](LICENSE).
