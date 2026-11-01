//===----------------------------------------------------------------------===//
//
// This source file is part of the SwiftOpenAPIGenerator open source project
//
// Copyright (c) 2023 Apple Inc. and the SwiftOpenAPIGenerator project authors
// Licensed under Apache License v2.0
//
// See LICENSES/Apache-2.0.txt and THIRD_PARTY_NOTICES.md in the repository root.
// Modified for molo: log only operation IDs, methods and status codes;
// remove body buffering, headers, URLs and error descriptions from logs.
//
// SPDX-License-Identifier: Apache-2.0
//
//===----------------------------------------------------------------------===//

import Foundation
import HTTPTypes
import Logging
import OpenAPIRuntime

/// Logs request outcomes without inspecting payloads or credential-bearing metadata.
struct LoggingMiddleware: ClientMiddleware {
    private let logger: Logger

    init(logger: Logger = Logger(label: "news.molo.api")) {
        self.logger = logger
    }

    func intercept(
        _ request: HTTPRequest,
        body: HTTPBody?,
        baseURL: URL,
        operationID: String,
        next: (HTTPRequest, HTTPBody?, URL) async throws -> (HTTPResponse, HTTPBody?)
    ) async throws -> (HTTPResponse, HTTPBody?) {
        let metadata: Logger.Metadata = [
            "method": .stringConvertible(request.method),
            "operation": .string(operationID)
        ]
        logger.debug("Request", metadata: metadata)
        do {
            let (response, responseBody) = try await next(request, body, baseURL)
            logger.debug("Response", metadata: metadata.merging([
                "status": .stringConvertible(response.status.code)
            ]) { _, new in new })
            return (response, responseBody)
        } catch {
            // Error descriptions may contain request URLs, headers or response bodies.
            logger.warning("Request failed", metadata: metadata)
            throw error
        }
    }
}
