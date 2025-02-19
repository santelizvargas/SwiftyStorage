//
//  CacheStorage.swift
//  SwiftyStorage
//
//  Created by Steven Santeliz on 18/2/25.
//

import SwiftUI

// MARK: - Property Wrapper

/// A property wrapper for managing in-memory caching in a type-safe way.
/// This wrapper enables seamless interaction with a shared memory cache, providing
/// efficient data retrieval without persistent storage.
///
/// ## Features:
/// - Type-safe access to stored values.
/// - Works with `SwiftUI` as a `DynamicProperty`, allowing direct binding to UI components.
/// - Provides a default value to prevent unexpected `nil` results.
/// - Uses `SharedMemoryCache` for optimized in-memory storage.
///
/// ## Example Usage:
/// ```swift
/// @CacheStorage("userTheme", defaultValue: "Light")
/// var userTheme: String
///
/// @CacheStorage("sessionToken")
/// var sessionToken: String? // Defaults to nil
/// ```
///
/// The cache is **not persistent** and will be cleared when the app is restarted.
@available(iOS 13.0, *)
@frozen
@propertyWrapper
@MainActor
public struct CacheStorage<Key: Hashable, Value>: DynamicProperty {
    /// The key used to store and retrieve the value in cache.
    private let key: Key

    /// The default value returned when no value exists in cache.
    private let defaultValue: Value

    /// The shared in-memory cache instance.
    private let storage: MemoryCache<Key, Value> = SharedMemoryCache.getCache()

    /// The stored value, managed via `@State` to trigger SwiftUI updates.
    @State private var value: Value

    /// Initializes the property wrapper with a key and a default value.
    ///
    /// - Parameters:
    ///   - key: The key used for storing the value in cache.
    ///   - defaultValue: The default value returned when no stored value exists.
    public init(_ key: Key, defaultValue: Value) {
        self.key = key
        self.defaultValue = defaultValue
        _value = State(initialValue: storage[key] ?? defaultValue)
    }

    /// The wrapped value stored in cache.
    ///
    /// - When setting:
    ///   - Updates the value in cache.
    /// - When getting:
    ///   - Returns the stored value if available.
    ///   - Otherwise, returns the `defaultValue`.
    public var wrappedValue: Value {
        get { value }
        nonmutating set {
            value = newValue
            storage[key] = newValue
        }
    }

    /// Provides a `Binding<Value>` for SwiftUI, allowing direct two-way binding in UI components.
    ///
    /// ## Example Usage:
    /// ```swift
    /// Toggle("Enable Dark Mode", isOn: $isDarkMode)
    /// ```
    public var projectedValue: Binding<Value> {
        Binding { wrappedValue } set: { newValue in
            wrappedValue = newValue
        }
    }
}

// MARK: - Optional Storage Init

/// Extension for handling optional values in `CacheStorage`.
/// Allows initializing a `CacheStorage` property without specifying a default value.
///
/// ## Example Usage:
/// ```swift
/// @CacheStorage("userSession")
/// var userSession: String? // Defaults to nil
/// ```
@available(iOS 13.0, *)
public extension CacheStorage where Value: ExpressibleByNilLiteral {
    /// Initializes an optional cache property with a key.
    /// - Parameter key: The key used for storage in memory cache.
    init(_ key: Key) {
        self.init(key, defaultValue: nil)
    }
}
