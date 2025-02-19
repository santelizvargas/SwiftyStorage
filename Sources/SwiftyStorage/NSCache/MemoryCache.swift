//
//  MemoryCache.swift
//  SwiftyStorage
//
//  Created by Steven Santeliz on 18/2/25.
//

import Foundation

/// A generic in-memory cache that stores key-value pairs using `NSCache` for efficient caching.
///
/// - Important: This cache automatically removes objects under memory pressure.
/// - Note: The keys must conform to `Hashable`.
///
/// ## Example Usage:
/// ```swift
/// let cache = MemoryCache<String, Int>()
/// cache["user_id"] = 42
/// print(cache["user_id"]) // Optional(42)
/// cache["user_id"] = nil  // Removes the value
/// ```
public final class MemoryCache<Key: Hashable, Value> {
    
    /// The internal NSCache instance managing cached objects.
    private let cache = NSCache<CacheKey, CacheValue>()
    
    // MARK: - Initializer
    
    /// Creates an empty `MemoryCache` instance.
    public init() {}

    // MARK: - Cache Value

    /// A wrapper class that stores the value inside the cache.
    private final class CacheValue {
        let value: Value

        /// Initializes a cache value wrapper.
        /// - Parameter value: The value to store in cache.
        init(_ value: Value) {
            self.value = value
        }
    }

    // MARK: - Cache Key

    /// A wrapper class that ensures `Hashable` keys work correctly in `NSCache`.
    private final class CacheKey: NSObject {
        let key: Key

        /// Initializes a cache key wrapper.
        /// - Parameter key: The key to store in cache.
        init(_ key: Key) {
            self.key = key
        }

        /// Checks equality between cache keys.
        override func isEqual(_ object: Any?) -> Bool {
            guard let other = object as? CacheKey else { return false }
            return key == other.key
        }

        /// Provides a hash value for the cache key.
        override var hash: Int {
            key.hashValue
        }
    }

    // MARK: - Cache Management

    /// Retrieves a value from the cache.
    /// - Parameter key: The key associated with the value.
    /// - Returns: The cached value, or `nil` if not found.
    private func getValue(for key: Key) -> Value? {
        let cacheKey = CacheKey(key)
        return cache.object(forKey: cacheKey)?.value
    }

    /// Stores a value in the cache.
    /// - Parameters:
    ///   - value: The value to store.
    ///   - key: The key associated with the value.
    private func setValue(_ value: Value, for key: Key) {
        let cacheKey = CacheKey(key)
        cache.setObject(CacheValue(value), forKey: cacheKey)
    }

    /// Removes a value from the cache.
    /// - Parameter key: The key of the value to remove.
    private func removeValue(for key: Key) {
        let cacheKey = CacheKey(key)
        cache.removeObject(forKey: cacheKey)
    }

    // MARK: - Subscript Access

    /// Provides subscript access to the cache for setting and retrieving values.
    ///
    /// - Example:
    /// ```swift
    /// cache["username"] = "JohnDoe"
    /// print(cache["username"]) // Optional("JohnDoe")
    /// ```
    public subscript(_ key: Key) -> Value? {
        get { getValue(for: key) }
        set {
            if let newValue = newValue {
                setValue(newValue, for: key)
            } else {
                removeValue(for: key)
            }
        }
    }
}
