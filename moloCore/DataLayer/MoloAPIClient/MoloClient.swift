//
//  MoloClient.swift
//  MoloAPIClient
//

import Domain
import Foundation
import Logging
import OpenAPIRuntime
import OpenAPIURLSession

public struct MoloClient {
    public let api: any APIProtocol

    internal init(api: any APIProtocol) {
        self.api = api
    }

    public init() {
        guard let url = try? Servers.Server1.url() else {
            fatalError("Could not construct URL for MoloClient")
        }

        let authToken = (try? TokenStore.shared.value(for: .access)) ?? ""
        let tempAuthToken = try? TokenStore.shared.value(for: .reset)

        var logger = Logger(label: "api.client")
        #if DEBUG
        logger.logLevel = .debug
        #else
        logger.logLevel = .warning
        #endif

        self.init(
            api: Client(
                serverURL: url,
                transport: URLSessionTransport(),
                middlewares: [
                    LoggingMiddleware(logger: logger),
                    AuthenticationMiddleware(authorizationHeaderFieldValue: tempAuthToken ?? authToken)
                ]
            )
        )
    }
}
