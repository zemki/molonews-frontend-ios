import Foundation
import HTTPTypes
import Logging
import OpenAPIRuntime
import XCTest

final class LoggingMiddlewareTests: XCTestCase {
    func testLogsOnlySafeMetadataAndPreservesPayloads() async throws {
        let capture = LogCapture()
        let middleware = LoggingMiddleware(logger: Logger(label: "test") { _ in CapturingLogHandler(capture: capture) })
        var request = HTTPRequest(method: .post, scheme: "https", authority: "example.com", path: "/token/?secret=query-value")
        request.headerFields[.authorization] = "Bearer private-auth-value"
        let requestData = Data("{\"password\":\"private-password-value\"}".utf8)
        let responseData = Data("{\"access\":\"private-access-value\"}".utf8)
        let response = HTTPResponse(status: .ok, headerFields: [.setCookie: "private-cookie-value"])
        let (result, body) = try await middleware.intercept(request, body: HTTPBody(requestData),
            baseURL: URL(string: "https://example.com")!, operationID: "token_create") { forwarded, body, _ in
                XCTAssertEqual(forwarded.headerFields[.authorization], request.headerFields[.authorization])
                let forwardedData = try await Data(collecting: body!, upTo: 1024)
                XCTAssertEqual(forwardedData, requestData)
                return (response, HTTPBody(responseData))
            }
        XCTAssertEqual(result.status, .ok)
        let returnedData = try await Data(collecting: body!, upTo: 1024)
        XCTAssertEqual(returnedData, responseData)
        XCTAssertEqual(capture.records.count, 2)
        XCTAssertEqual(Set(capture.records[0].metadata.keys), ["method", "operation"])
        XCTAssertEqual(Set(capture.records[1].metadata.keys), ["method", "operation", "status"])
        let logs = String(describing: capture.records)
        for secret in ["query-value", "private-auth-value", "private-password-value", "private-access-value", "private-cookie-value", "/token/"] {
            XCTAssertFalse(logs.contains(secret))
        }
    }

    func testTransportFailureDoesNotLogSensitiveErrorDescription() async throws {
        let capture = LogCapture()
        let middleware = LoggingMiddleware(logger: Logger(label: "test") { _ in CapturingLogHandler(capture: capture) })
        let request = HTTPRequest(method: .get, scheme: "https", authority: "example.com", path: "/private?token=secret")
        do {
            _ = try await middleware.intercept(request, body: nil, baseURL: URL(string: "https://example.com")!,
                operationID: "users_get_user_details") { _, _, _ in
                    throw NSError(domain: "test", code: 1, userInfo: [NSLocalizedDescriptionKey: "private-error-value"])
                }
            XCTFail("The transport error must propagate")
        } catch {
            XCTAssertEqual((error as NSError).code, 1)
        }
        XCTAssertEqual(capture.records.last?.message, "Request failed")
        XCTAssertFalse(String(describing: capture.records).contains("private-error-value"))
    }

    func testWarningLogLevelSuppressesRequestAndResponseLogs() async throws {
        let capture = LogCapture()
        var logger = Logger(label: "test") { _ in CapturingLogHandler(capture: capture) }
        logger.logLevel = .warning
        let middleware = LoggingMiddleware(logger: logger)
        let request = HTTPRequest(method: .get, scheme: "https", authority: "example.com", path: "/articles/")
        _ = try await middleware.intercept(request, body: nil, baseURL: URL(string: "https://example.com")!,
            operationID: "articles_list") { _, _, _ in (HTTPResponse(status: .ok), nil) }
        XCTAssertTrue(capture.records.isEmpty)
    }
}

private final class LogCapture: @unchecked Sendable {
    struct Record {
        let message: String
        let metadata: Logger.Metadata
    }

    private let lock = NSLock()
    private var storage: [Record] = []

    var records: [Record] {
        lock.lock()
        defer { lock.unlock() }
        return storage
    }

    func append(_ record: Record) {
        lock.lock()
        defer { lock.unlock() }
        storage.append(record)
    }
}

private struct CapturingLogHandler: LogHandler {
    let capture: LogCapture
    var logLevel: Logger.Level = .debug
    var metadata: Logger.Metadata = [:]

    subscript(metadataKey key: String) -> Logger.Metadata.Value? {
        get { metadata[key] }
        set { metadata[key] = newValue }
    }

    func log(level: Logger.Level, message: Logger.Message, metadata: Logger.Metadata?,
             source: String, file: String, function: String, line: UInt) {
        capture.append(.init(message: message.description, metadata: metadata ?? [:]))
    }
}
