//
//  StorageProtocol.swift
//  SwiftyStorage
//
//  Created by Steven Santeliz on 15/2/25.
//

/// A protocol defining a generic storage mechanism.
public protocol StorageProtocol {
    /// Retrieves the stored value for a given key.
    /// - Parameters:
    ///   - key: The key associated with the value.
    ///   - type: The expected type of the value.
    /// - Returns: The decoded value if found, otherwise nil.
    func getValue<T: Codable>(forKey key: String) -> T?

    /// Saves a value to the storage.
    /// - Parameters:
    ///   - value: The value to store.
    ///   - key: The key to store the value under.
    func setValue<T: Codable>(_ value: T, forKey key: String)

    /// Removes the stored value for a given key.
    /// - Parameter key: The key associated with the value to remove.
    func removeValue(forKey key: String)
}
