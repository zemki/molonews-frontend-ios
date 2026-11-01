import Foundation
import Security

/// Stores all session credentials in one device-local Keychain item.
public final class TokenStore {
    public enum Token: String, CaseIterable {
        // Keep the old preferences keys for migration from earlier app versions.
        case access = "de.uni-bremen.molonews.token"
        case refresh = "de.uni-bremen.molonews.refresh.token"
        case reset = "de.uni-bremen.molonews.reset.token"
    }

    public static let shared = TokenStore()
    public static let didChange = Notification.Name("news.molo.credentialsChanged")

    private struct Credentials: Codable {
        var access: String?
        var refresh: String?
        var reset: String?

        var isEmpty: Bool { access == nil && refresh == nil && reset == nil }

        subscript(token: Token) -> String? {
            get {
                switch token {
                case .access: return access
                case .refresh: return refresh
                case .reset: return reset
                }
            }
            set {
                switch token {
                case .access: access = newValue
                case .refresh: refresh = newValue
                case .reset: reset = newValue
                }
            }
        }
    }

    private let service: String
    private let defaults: UserDefaults
    private let keychain: KeychainAccess
    private let lock = NSLock()

    init(service: String = "news.molo.credentials", defaults: UserDefaults = .standard,
         keychain: KeychainAccess = SystemKeychainAccess()) {
        self.service = service
        self.defaults = defaults
        self.keychain = keychain
    }

    public func value(for token: Token) throws -> String? {
        try withLock { try readCredentials()[token] }
    }

    public func set(_ value: String?, for token: Token) throws {
        try withLock {
            var credentials = try readCredentials()
            credentials[token] = value
            try writeCredentials(credentials)
            removeLegacyTokens()
        }
        notifyChange()
    }

    /// Replaces both login tokens atomically and discards any password-reset token.
    public func setSession(accessToken: String, refreshToken: String? = nil) throws {
        try withLock {
            try writeCredentials(Credentials(access: accessToken, refresh: refreshToken))
            removeLegacyTokens()
        }
        notifyChange()
    }

    public func clear() throws {
        try withLock {
            try writeCredentials(Credentials())
            removeLegacyTokens()
        }
        notifyChange()
    }

    private var query: [String: Any] {
        [kSecClass as String: kSecClassGenericPassword,
         kSecAttrService as String: service,
         kSecAttrAccount as String: "session"]
    }

    private func readCredentials() throws -> Credentials {
        var query = query
        query[kSecReturnData as String] = true
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        let (status, data) = keychain.copyMatching(query)
        switch status {
        case errSecSuccess:
            guard let data else { throw TokenStoreError.invalidData }
            let credentials = try JSONDecoder().decode(Credentials.self, from: data)
            // A Keychain session always takes precedence over stale preferences.
            removeLegacyTokens()
            return credentials
        case errSecItemNotFound:
            var credentials = Credentials()
            for token in Token.allCases {
                credentials[token] = defaults.string(forKey: token.rawValue)
            }
            if !credentials.isEmpty {
                // Never discard the old tokens if the Keychain write fails.
                try writeCredentials(credentials)
                removeLegacyTokens()
            }
            return credentials
        default:
            throw TokenStoreError.keychain(status)
        }
    }

    private func writeCredentials(_ credentials: Credentials) throws {
        if credentials.isEmpty {
            let status = keychain.delete(query)
            guard status == errSecSuccess || status == errSecItemNotFound else {
                throw TokenStoreError.keychain(status)
            }
            return
        }

        let attributes: [String: Any] = [
            kSecValueData as String: try JSONEncoder().encode(credentials),
            // Background push handling can access credentials after the first unlock.
            // The item is neither synchronized nor transferred to another device.
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
        ]
        var status = keychain.update(query, attributes: attributes)
        if status == errSecItemNotFound {
            status = keychain.add(query.merging(attributes) { _, new in new })
        }
        guard status == errSecSuccess else { throw TokenStoreError.keychain(status) }
    }

    private func removeLegacyTokens() {
        for token in Token.allCases {
            defaults.removeObject(forKey: token.rawValue)
        }
    }

    private func withLock<T>(_ operation: () throws -> T) rethrows -> T {
        lock.lock()
        defer { lock.unlock() }
        return try operation()
    }

    private func notifyChange() {
        // Post after unlocking so observers may safely read the new credentials.
        NotificationCenter.default.post(name: Self.didChange, object: self)
    }
}

enum TokenStoreError: Error {
    case keychain(OSStatus)
    case invalidData
}

protocol KeychainAccess {
    func copyMatching(_ query: [String: Any]) -> (OSStatus, Data?)
    func add(_ attributes: [String: Any]) -> OSStatus
    func update(_ query: [String: Any], attributes: [String: Any]) -> OSStatus
    func delete(_ query: [String: Any]) -> OSStatus
}

struct SystemKeychainAccess: KeychainAccess {
    func copyMatching(_ query: [String: Any]) -> (OSStatus, Data?) {
        var result: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        return (status, result as? Data)
    }

    func add(_ attributes: [String: Any]) -> OSStatus {
        SecItemAdd(attributes as CFDictionary, nil)
    }

    func update(_ query: [String: Any], attributes: [String: Any]) -> OSStatus {
        SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
    }

    func delete(_ query: [String: Any]) -> OSStatus {
        SecItemDelete(query as CFDictionary)
    }
}
