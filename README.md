<div align="center">
    <img src="moloApp/moloApp/Assets.xcassets/AppIcon.appiconset/appstore.png" alt="molo" width="120"/>
    <h2>molo iOS app</h2>
    <p>Local news and events, collected and curated in one place</p>

[![Project Status: Active](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
![This is a research software](https://img.shields.io/badge/research-software-blue?style=plastic)
![License: AGPL-3.0](https://img.shields.io/badge/license-AGPL--3.0-blue)
![Swift 5 language mode](https://img.shields.io/badge/swift-5-orange)
![iOS 18.0+](https://img.shields.io/badge/iOS-18.0%2B-lightgrey)
</div>

### Quick links

- 📱 App Store: [molo.news](https://apps.apple.com/us/app/molo.news/id1486601544)
- 🖥️ Backend (Django, REST API): [zemki/molonews-django-backend](https://github.com/zemki/molonews-django-backend)
- 🤝 Contributing: [CONTRIBUTING.md](CONTRIBUTING.md)

## What is molo?

molo is a free/libre Open Source platform for local information. It collects news
and events from many local sources – newspapers, municipalities, cultural venues,
clubs and initiatives – and makes them available in one place, sorted by region and
topic. Organizations and citizens can also publish their own articles and events.

It's developed by the [ZeMKI (Centre for Media, Communication and Information Research)](https://zemki.uni-bremen.de/)
at the [University of Bremen](https://www.uni-bremen.de/). The iOS app was built
together with the agency convelop.

This repository contains the **iOS app**: a native SwiftUI application (iPhone, iOS 18+)
that talks to the molo backend's REST API (v4) and provides

- a **feed** of local articles filtered by location, topics and sources
- an **events** section with categories, date ranges and calendar export
- **explore** and **search** across articles, events and organizations
- a **watchlist** (bookmarks) and organization detail pages
- **participate**: registered users can post and manage their own articles and events
- onboarding, location/topic/source selection, account management and in-app feedback
- optional **push notifications** via Firebase Cloud Messaging and `molonews://` deep links

The code is published for research documentation purposes and so that others can
run the app against their own instance of the
[molo backend](https://github.com/zemki/molonews-django-backend). The user interface
is currently German only (`moloResources/Strings/de.lproj`).

## Getting started

### Requirements

- macOS with **Xcode 26 or later** (the projects were last upgraded with Xcode 26.x and
  use the iOS 26 SDK; Swift code is compiled in Swift 5 language mode)
- an iPhone or simulator running **iOS 18.0 or later**
- a **Firebase project** of your own (see below)
- optional: [SwiftGen](https://github.com/SwiftGen/SwiftGen) (`brew install swiftgen`)
  if you change colors, images or strings in `moloResources`

All Swift package dependencies are resolved by Xcode via Swift Package Manager.

### 1. Clone and open the workspace

```bash
git clone <repository-url> molo-ios && cd molo-ios
open molo.xcworkspace
```

Always open `molo.xcworkspace`, not a single `.xcodeproj`: the workspace ties the five
Xcode projects together. Build and run the `moloApp` scheme.

### 2. Firebase configuration (required)

Push notifications use Firebase Cloud Messaging. The Xcode project references
`moloApp/GoogleService-Info.plist`, but that file is **git-ignored** because it contains
project-specific keys. **Without it the build fails.**

1. Create a Firebase project at <https://console.firebase.google.com/>.
2. Add an iOS app with the bundle identifier you are going to use (the default is
   `news.molo.app`) and download its `GoogleService-Info.plist`.
3. Place the file at `moloApp/GoogleService-Info.plist`.

Alternatively copy the template and fill in your values:

```bash
cp moloApp/GoogleService-Info.plist.example moloApp/GoogleService-Info.plist
```

### 3. Signing and bundle identifier

The project uses automatic signing but ships without a development team. For your own
Apple developer account, select the `moloApp` target in Xcode, open
*Signing & Capabilities*, pick your team and change the bundle identifier
(`PRODUCT_BUNDLE_IDENTIFIER`, default `news.molo.app`). The bundle identifier must match
the one registered in Firebase. The `aps-environment` entitlement
(`moloApp/moloApp/moloApp.entitlements`) requires the Push Notifications capability on
your App ID.

### 4. Point the app at your own backend

The API client is generated from `moloCore/DataLayer/MoloAPIClient/openapi.yaml` and
reads its server URL from the `servers` entry of that file (`Servers.Server1.url()` in
`MoloClient.swift`). The default is `https://redaktion.molo.news/api/v4`. To use your
own backend, change that URL, e.g.

```yaml
servers:
- url: https://your-molo-backend.example.org/api/v4
```

`moloApp/moloApp/Info.plist` also carries a `BaseURL` key with the same value; keep it in
sync. Note that this key is currently not read by the Swift code – the generated
`Servers` type is the single source of truth.

## Project structure

The workspace consists of five Xcode projects whose framework targets form a strict
layering: `moloCore` → `moloUI` → `moloFeatures` → `moloApp`. `moloResources` is shared
by all layers.

```
molo.xcworkspace          Workspace referencing the five projects below
moloApp/                  App target (@main, AppDelegate, tab bar, push routing, DI registration)
moloCore/
  Domain/                 Models, repository protocols, use cases (UseCaseState/Error), DI promises
  DataLayer/              Repository implementations, OpenAPI client, DTO -> domain mappers
  Routing/                Coordinator (navigation stacks per tab, sheet routes)
moloUI/                   Design-system frameworks: Atoms, Molecules, Organisms, Templates,
                          Dimensions, Modifiers (atomic design, SwiftUI)
moloFeatures/             One framework per feature: Feed, Events, Explore, Watchlist,
                          Participate, ArticleList/Detail, EventList/Details, Search,
                          Account, Onboarding, Postings, LocationSelection, ...
moloResources/            Assets (Colors, Icons, Images) and Strings frameworks, SwiftGen config
```

### Architecture

- **Domain layer** (`Domain`): plain Swift models, repository protocols
  (`*RepositoryType`) and use cases. Use cases subclass `BaseUseCaseExecuter<T>` and
  expose `execute() -> AnyPublisher<UseCaseState<T>, Never>` (Combine), resolving the
  device id from the account repository before each call.
- **Data layer** (`DataLayer`): repositories are `actor`s implementing the domain
  protocols on top of the generated OpenAPI client; mappers convert API DTOs to domain
  models. Device id and user settings are persisted in `UserDefaults`. Access, refresh and
  password-reset tokens are stored together in a device-local Keychain item.
  Existing tokens are migrated from preferences after a successful Keychain write;
  logout and account deletion remove all session tokens.
- **Routing** (`Routing`): a `@MainActor` `Coordinator` holds a `NavigationStack` path
  per tab and a list of presented sheets (`SheetRoute`).
- **Features** (`moloFeatures`): each screen follows an **MVI-style** pattern with four
  files – `*Intent` (enum of user actions), `*State` (enum of view states),
  `*ViewModel` (`ObservableObject`, `@Published state`, `executeIntent(_:)`) and
  `*View` (SwiftUI). Features depend on `Domain`, `Routing`, `moloUI` and
  `moloResources`, not on each other (except list components reused by several tabs).
- **Dependency injection**: [Factory](https://github.com/hmlongco/Factory). Lower
  layers declare `promised()` factories on `Container` (e.g. `apiClient`,
  `coordinator`, `*Repository`); the app target fulfils them in
  `moloApp/moloApp/DI/Factory+Registration.swift` via `AutoRegistering`.
- **Resources**: colors, images and localized strings are type-safe enums generated
  by SwiftGen (`moloResources/swiftgen.yml`); the generated files are committed.

## API / backend

The app consumes API **v4** of the molo backend. The client is **generated at build
time** by [swift-openapi-generator](https://github.com/apple/swift-openapi-generator),
which is attached to the `DataLayer` target as a SwiftPM build plugin:

- `moloCore/DataLayer/MoloAPIClient/openapi.yaml` – the OpenAPI 3.0 specification
- `moloCore/DataLayer/MoloAPIClient/openapi-generator-config.yaml` – generates `types`
  and `client` with `namingStrategy: idiomatic` and `accessModifier: public`
- `MoloClient.swift` wraps the generated `Client` with `URLSessionTransport` and two
  middlewares: logging of operation IDs, HTTP methods and status codes (swift-log),
  and an `Authorization` header
  taken from the stored user token. Request/response bodies, headers, URLs and error
  descriptions are never logged; Release builds suppress debug request logs.

No generated code is checked in. To update the client after a backend change, export
the current spec from your backend (`/api/v4/swagger/` on a molo backend instance),
replace `openapi.yaml` and rebuild – the plugin regenerates `Types.swift` and
`Client.swift` into the build directory. Do not edit generated code by hand.

### Dependencies

| Package | Purpose |
| --- | --- |
| [firebase-ios-sdk](https://github.com/firebase/firebase-ios-sdk) (FirebaseMessaging) | Push notifications |
| [Factory](https://github.com/hmlongco/Factory) | Dependency injection |
| [Kingfisher](https://github.com/onevcat/Kingfisher) | Image loading and caching |
| [swift-openapi-generator](https://github.com/apple/swift-openapi-generator), [-runtime](https://github.com/apple/swift-openapi-runtime), [-urlsession](https://github.com/apple/swift-openapi-urlsession) | Generated API client |
| [swift-log](https://github.com/apple/swift-log) | Logging |
| [SwiftUI-Flow](https://github.com/tevelee/SwiftUI-Flow) | Flow layouts (tag chips) |

Exact versions are pinned in `molo.xcworkspace/xcshareddata/swiftpm/Package.resolved`.

## Development

If you have reached this section, chances are high you want to

- run molo in your own region with your own backend,
- understand the app or hack on a local version,
- improve molo.

Start with the *Getting started* section above and [CONTRIBUTING.md](CONTRIBUTING.md),
which also describes the module boundaries and coding guidelines. Please report
security issues privately to [kontakt@molo.news](mailto:kontakt@molo.news) or via
GitHub's private vulnerability reporting, not as public issues.

### Security regression tests

The shared `moloCoreTests` scheme tests Keychain migration, session replacement,
logout, storage failures and log redaction without a backend or Firebase setup.
It compiles the production token store and logging middleware directly into an
isolated macOS test bundle. Select **My Mac** and run **Product > Test**,
or run the tests from the command line:

```bash
xcodebuild -workspace molo.xcworkspace -scheme moloCoreTests \
  -destination 'platform=macOS' test
```

## Contact

Questions, feedback or interest in running molo in your region:
[kontakt@molo.news](mailto:kontakt@molo.news)

## Licenses

### Software

molo is a free/libre Open Source Software for local news and events.
Copyright (C) 2026 ZeMKI, Universität Bremen

The software is released under the AGPL-3.0 license, which you can read in our
[license file](./LICENSE).

### Third-party components

Third-party Swift packages (Firebase, Factory, Kingfisher, the Swift OpenAPI
packages, swift-log, SwiftUI-Flow and their transitive dependencies) keep their own
licenses as stated in the respective repositories. `AuthClientMiddleware.swift` and
`LoggingMiddleware.swift` are adapted from SwiftOpenAPIGenerator examples and retain
their Apache-2.0 license. See [third-party notices](THIRD_PARTY_NOTICES.md) for
attribution and the included license text.
