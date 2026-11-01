import Foundation
import Security
import XCTest

final class TokenStoreTests: XCTestCase {
    private var defaults: UserDefaults!
    private var suiteName: String!
    private var keychain: MemoryKeychain!
    private var store: TokenStore!

    override func setUp() {
        super.setUp()
        suiteName = "news.molo.tests.\(UUID().uuidString)"
        defaults = UserDefaults(suiteName: suiteName)!
        keychain = MemoryKeychain()
        store = TokenStore(service: suiteName, defaults: defaults, keychain: keychain)
    }

    override func tearDown() {
        defaults.removePersistentDomain(forName: suiteName)
        super.tearDown()
    }

    func testMigratesAllLegacyTokensBeforeRemovingPreferences() throws {
        seedLegacyTokens()
        XCTAssertEqual(try store.value(for: .access), "old-access")
        XCTAssertEqual(try store.value(for: .refresh), "old-refresh")
        XCTAssertEqual(try store.value(for: .reset), "old-reset")
        for token in TokenStore.Token.allCases {
            XCTAssertNil(defaults.object(forKey: token.rawValue))
        }
        XCTAssertEqual(keychain.attributes[kSecAttrAccessible as String] as? String,
                       kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly as String)
    }

    func testFailedMigrationPreservesEveryLegacyToken() {
        seedLegacyTokens()
        keychain.writeStatus = errSecAuthFailed
        XCTAssertThrowsError(try store.value(for: .access))
        XCTAssertEqual(defaults.string(forKey: TokenStore.Token.access.rawValue), "old-access")
        XCTAssertEqual(defaults.string(forKey: TokenStore.Token.refresh.rawValue), "old-refresh")
        XCTAssertEqual(defaults.string(forKey: TokenStore.Token.reset.rawValue), "old-reset")
        XCTAssertNil(keychain.data)
    }

    func testInaccessibleKeychainDoesNotFallBackToPreferences() {
        seedLegacyTokens()
        keychain.readStatus = errSecInteractionNotAllowed
        XCTAssertThrowsError(try store.value(for: .access))
        XCTAssertNil(keychain.data)
        XCTAssertNotNil(defaults.string(forKey: TokenStore.Token.access.rawValue))
    }

    func testKeychainSessionWinsOverStalePreferences() throws {
        try store.setSession(accessToken: "current-access", refreshToken: "current-refresh")
        seedLegacyTokens()
        XCTAssertEqual(try store.value(for: .access), "current-access")
        XCTAssertEqual(try store.value(for: .refresh), "current-refresh")
        XCTAssertNil(try store.value(for: .reset))
        XCTAssertNil(defaults.string(forKey: TokenStore.Token.access.rawValue))
    }

    func testNewSessionReplacesResetAndRefreshTokensAtomically() throws {
        try store.setSession(accessToken: "old-access", refreshToken: "old-refresh")
        try store.set("old-reset", for: .reset)
        try store.setSession(accessToken: "activation-access")
        XCTAssertEqual(try store.value(for: .access), "activation-access")
        XCTAssertNil(try store.value(for: .refresh))
        XCTAssertNil(try store.value(for: .reset))
    }

    func testFailedSessionReplacementLeavesPreviousSessionIntact() throws {
        try store.setSession(accessToken: "old-access", refreshToken: "old-refresh")
        keychain.writeStatus = errSecAuthFailed
        XCTAssertThrowsError(try store.setSession(accessToken: "new-access", refreshToken: "new-refresh"))
        XCTAssertEqual(try store.value(for: .access), "old-access")
        XCTAssertEqual(try store.value(for: .refresh), "old-refresh")
    }

    func testLogoutRemovesAllTokensWithoutRevivingLegacySession() throws {
        try store.setSession(accessToken: "current-access", refreshToken: "current-refresh")
        try store.set("current-reset", for: .reset)
        seedLegacyTokens()
        try store.clear()
        for token in TokenStore.Token.allCases {
            XCTAssertNil(try store.value(for: token))
            XCTAssertNil(defaults.object(forKey: token.rawValue))
        }
        XCTAssertNil(keychain.data)
        XCTAssertNoThrow(try store.clear())
    }

    func testRemovingResetTokenKeepsLoginSession() throws {
        try store.setSession(accessToken: "current-access", refreshToken: "current-refresh")
        try store.set("current-reset", for: .reset)
        try store.set(nil, for: .reset)
        XCTAssertNil(try store.value(for: .reset))
        XCTAssertEqual(try store.value(for: .access), "current-access")
        XCTAssertEqual(try store.value(for: .refresh), "current-refresh")
    }

    func testObserversCanReadCompleteSessionDuringChangeNotification() throws {
        let changed = expectation(description: "Credentials changed")
        changed.assertForOverFulfill = true
        let observer = NotificationCenter.default.addObserver(forName: TokenStore.didChange, object: nil, queue: nil) { [self] note in
            guard note.object as? TokenStore === store else { return }
            XCTAssertEqual(try? store.value(for: .access), "new-access")
            XCTAssertEqual(try? store.value(for: .refresh), "new-refresh")
            changed.fulfill()
        }
        defer { NotificationCenter.default.removeObserver(observer) }
        try store.setSession(accessToken: "new-access", refreshToken: "new-refresh")
        wait(for: [changed], timeout: 1)
    }

    func testCorruptKeychainDataDoesNotReviveLegacySession() {
        seedLegacyTokens()
        keychain.data = Data("invalid-credential-data".utf8)
        XCTAssertThrowsError(try store.value(for: .access))
    }

    func testSystemKeychainRoundTrip() throws {
        // A unique service and preferences suite isolate this from all app credentials.
        let systemStore = TokenStore(service: suiteName, defaults: defaults)
        defer { try? systemStore.clear() }
        try systemStore.setSession(accessToken: "sample-access", refreshToken: "sample-refresh")
        XCTAssertEqual(try systemStore.value(for: .access), "sample-access")
        XCTAssertEqual(try systemStore.value(for: .refresh), "sample-refresh")
        try systemStore.clear()
        XCTAssertNil(try systemStore.value(for: .access))
    }

    private func seedLegacyTokens() {
        defaults.set("old-access", forKey: TokenStore.Token.access.rawValue)
        defaults.set("old-refresh", forKey: TokenStore.Token.refresh.rawValue)
        defaults.set("old-reset", forKey: TokenStore.Token.reset.rawValue)
    }
}

private final class MemoryKeychain: KeychainAccess {
    var data: Data?
    var attributes: [String: Any] = [:]
    var readStatus: OSStatus?
    var writeStatus: OSStatus = errSecSuccess

    func copyMatching(_ query: [String: Any]) -> (OSStatus, Data?) {
        (readStatus ?? (data == nil ? errSecItemNotFound : errSecSuccess), data)
    }

    func add(_ attributes: [String: Any]) -> OSStatus {
        guard writeStatus == errSecSuccess else { return writeStatus }
        self.attributes = attributes
        data = attributes[kSecValueData as String] as? Data
        return errSecSuccess
    }

    func update(_ query: [String: Any], attributes: [String: Any]) -> OSStatus {
        guard writeStatus == errSecSuccess else { return writeStatus }
        guard data != nil else { return errSecItemNotFound }
        self.attributes = attributes
        data = attributes[kSecValueData as String] as? Data
        return errSecSuccess
    }

    func delete(_ query: [String: Any]) -> OSStatus {
        guard writeStatus == errSecSuccess else { return writeStatus }
        data = nil
        return errSecSuccess
    }
}
