//
//  DefaultsStorage.swift
//  SwiftyStorage
//
//  Created by Steven Santeliz on 15/2/25.
//

import SwiftyStorage
import Foundation

// MARK: - Property Wrapper

/// A property wrapper for managing `UserDefaults` storage in a type-safe way.
/// Automatically removes values from storage when `nil` is assigned.
///
/// - Example:
/// ```swift
/// @DefaultsStorage("username", defaultValue: "Guest")
/// var username: String
/// ```
///
/// When assigning `nil` to a wrapped optional value, the corresponding key is removed from `UserDefaults`.
@propertyWrapper
public struct DefaultsStorage<T: Codable> {
    private let key: String
    private let defaultValue: T
    private let storage = UserDefaultsStorage()

    /// Initializes the property wrapper with a key and a default value.
    /// - Parameters:
    ///   - key: The key used for storage.
    ///   - defaultValue: The default value returned when no stored value exists.
    public init(_ key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }

    /// The wrapped value for the property.
    ///
    /// - When setting:
    ///   - If the new value is `nil`, the corresponding key is removed from storage.
    ///   - Otherwise, the value is stored.
    /// - When getting:
    ///   - Returns the stored value if available.
    ///   - Otherwise, returns the `defaultValue`.
    public var wrappedValue: T {
        get { storage.getValue(forKey: key) ?? defaultValue }
        set {
            if let optionalValue = newValue as? AnyOptional, optionalValue.isNil {
                storage.removeValue(forKey: key)
            } else {
                storage.setValue(newValue, forKey: key)
            }
        }
    }
}

// MARK: - Optional Storage Init

/// Extension for handling optional values in `DefaultsStorage`.
/// Allows initializing a `DefaultsStorage` property with a `nil` default.
public extension DefaultsStorage where T: ExpressibleByNilLiteral {
    /// Initializes an optional storage property with a key.
    /// - Parameter key: The key used for storage.
    public init(_ key: String) {
        self.init(key, defaultValue: nil)
    }
}
