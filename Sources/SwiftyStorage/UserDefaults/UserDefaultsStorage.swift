//
//  UserDefaultsStorage.swift
//  SwiftyStorage
//
//  Created by Steven Santeliz on 15/2/25.
//

import Foundation

/// A concrete implementation of `StorageProtocol` using `UserDefaults`.
/// Handles encoding and decoding of `Codable` values.
public struct UserDefaultsStorage: StorageProtocol {
    private let container: UserDefaults
    private let encoder: JSONEncoder = .init()
    private let decoder: JSONDecoder = .init()

    /// Initializes the storage with an optional `UserDefaults` container.
    /// - Parameter container: The `UserDefaults` instance (default is `.standard`).
    public init(container: UserDefaults = .standard) {
        self.container = container
    }

    /// Retrieves the stored value for a given key.
    /// - Parameters:
    ///   - key: The key associated with the value.
    /// - Returns: The decoded value if found, otherwise nil.
    public func getValue<T: Codable>(forKey key: String) -> T? {
        guard let data = container.data(forKey: key) else { return nil }
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            debugPrint("❌ [UserDefaultsStorage] Failed to decode value for key '\(key)': \(error)")
            return nil
        }
    }

    /// Saves a value to the storage.
    /// - Parameters:
    ///   - value: The value to store.
    ///   - key: The key under which to store the value.
    public func setValue<T: Codable>(_ value: T, forKey key: String) {
        do {
            let data = try encoder.encode(value)
            container.set(data, forKey: key)
        } catch {
            debugPrint("❌ [UserDefaultsStorage] Failed to encode value for key '\(key)': \(error)")
        }
    }

    /// Removes the stored value for a given key.
    /// - Parameter key: The key associated with the value to remove.
    public func removeValue(forKey key: String) {
        container.removeObject(forKey: key)
        debugPrint("ℹ️ [UserDefaultsStorage] Removed value for key '\(key)'")
    }
}
