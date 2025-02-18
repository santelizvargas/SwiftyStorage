//
//  DefaultsStorage.swift
//  SwiftyStorage
//
//  Created by Steven Santeliz on 15/2/25.
//

import SwiftUI

// MARK: - Property Wrapper

/// A property wrapper for managing `UserDefaults` storage in a type-safe way.
/// This wrapper provides seamless interaction with `UserDefaults` by automatically
/// encoding and decoding `Codable` values.
///
/// ## Features:
/// - Type-safe access to stored values.
/// - Automatic removal of values from storage when `nil` is assigned.
/// - Default value support to prevent unexpected `nil` results.
/// - Works with `SwiftUI` as a `DynamicProperty`, allowing binding to UI components.
///
/// ## Example Usage:
/// ```swift
/// @DefaultsStorage("username", defaultValue: "Guest")
/// var username: String
///
/// @DefaultsStorage("userAge")
/// var userAge: Int? // Defaults to nil
/// ```
///
/// When assigning `nil` to a wrapped optional value, the corresponding key is removed from `UserDefaults`.
@available(iOS 13.0, *)
@frozen
@propertyWrapper
@MainActor
public struct DefaultsStorage<T: Codable>: DynamicProperty {
    /// The key used for storing the value in `UserDefaults`.
    private let key: String
    
    /// The default value to return when no value exists in `UserDefaults`.
    private let defaultValue: T
    
    /// A helper instance that interacts with `UserDefaults`.
    private let storage = UserDefaultsStorage()
    
    /// The stored value, managed via `@State` to trigger SwiftUI updates.
    @State private var value: T

    /// Initializes the property wrapper with a key and a default value.
    ///
    /// - Parameters:
    ///   - key: The key used to store the value in `UserDefaults`.
    ///   - defaultValue: The default value returned when no stored value exists.
    public init(_ key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
        _value = State(initialValue: storage.getValue(forKey: key) ?? defaultValue)
    }

    /// The wrapped value for the property.
    ///
    /// - When setting:
    ///   - If the new value is `nil`, the corresponding key is removed from `UserDefaults`.
    ///   - Otherwise, the value is stored using `UserDefaults`.
    /// - When getting:
    ///   - Returns the stored value if available.
    ///   - Otherwise, returns the `defaultValue`.
    public var wrappedValue: T {
        get { value }
        nonmutating set {
            value = newValue
            
            if let optionalValue = newValue as? AnyOptional, optionalValue.isNil {
                storage.removeValue(forKey: key)
            } else {
                storage.setValue(newValue, forKey: key)
            }
        }
    }
    
    /// Provides a `Binding<T>` for SwiftUI, allowing direct two-way binding in UI components.
    ///
    /// - Example Usage:
    /// ```swift
    /// TextField("Enter username", text: $username)
    /// ```
    public var projectedValue: Binding<T> {
        Binding { wrappedValue } set: { newValue in
            wrappedValue = newValue
        }
    }
}

// MARK: - Optional Storage Init

/// Extension for handling optional values in `DefaultsStorage`.
/// Allows initializing a `DefaultsStorage` property without specifying a default value.
///
/// ## Example Usage:
/// ```swift
/// @DefaultsStorage("userToken")
/// var userToken: String? // Defaults to nil
/// ```
@available(iOS 13.0, *)
public extension DefaultsStorage where T: ExpressibleByNilLiteral {
    /// Initializes an optional storage property with a key.
    /// - Parameter key: The key used for storage in `UserDefaults`.
    init(_ key: String) {
        self.init(key, defaultValue: nil)
    }
}
