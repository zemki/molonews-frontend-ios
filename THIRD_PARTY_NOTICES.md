# Third-party notices

The molo application code is licensed under [AGPL-3.0](LICENSE), except for
third-party material that retains its original license.

## Swift OpenAPI Generator middleware examples

The following files are adapted from the Swift OpenAPI Generator examples and
retain their Apache-2.0 license:

- `moloCore/DataLayer/MoloAPIClient/AuthClientMiddleware.swift`, from the
  [authentication client middleware example](https://github.com/apple/swift-openapi-generator/blob/1.10.2/Examples/auth-client-middleware-example/Sources/AuthenticationClientMiddleware/AuthenticationClientMiddleware.swift)
- `moloCore/DataLayer/MoloAPIClient/LoggingMiddleware.swift`, from the
  [swift-log middleware example](https://github.com/apple/swift-openapi-generator/blob/1.10.2/Examples/logging-middleware-swift-log-example/Sources/LoggingMiddleware/LoggingMiddleware.swift)

Copyright (c) 2023 Apple Inc. and the SwiftOpenAPIGenerator project authors.
Copyright 2023 The SwiftOpenAPIGenerator Project.

The [Apache-2.0 license](LICENSES/Apache-2.0.txt) and the applicable
[upstream notice](LICENSES/SwiftOpenAPIGenerator-NOTICE.txt) are included.
The [upstream contributors](https://github.com/apple/swift-openapi-generator/blob/1.10.2/CONTRIBUTORS.txt)
are listed in the original project. Modified files carry notices describing the
molo adaptations. The logging middleware has been restricted to operation IDs,
HTTP methods and status codes, and no longer records bodies, headers or URLs.

## Swift package dependencies

The packages resolved by Swift Package Manager retain their own licenses and
notices in their respective repositories. Their source code and build artifacts
are not vendored in this repository. See the dependency links in [README.md](README.md#dependencies)
and `molo.xcworkspace/xcshareddata/swiftpm/Package.resolved` for exact versions.
