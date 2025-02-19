//
//  SharedMemoryCache.swift
//  SwiftyStorage
//
//  Created by Steven Santeliz on 18/2/25.
//

import Foundation

/// `SharedMemoryCache` manages and provides access to shared in-memory cache instances.
///
/// It ensures that multiple components of the application can reuse the same cache
/// while preventing redundant cache creation.
///
/// This implementation is **thread-safe**, utilizing an `actor` to avoid race conditions.
@available(iOS 13.0.0, *)
public actor SharedMemoryCache {
    
    /// Stores cache instances, indexed by their computed type-based keys.
    private static var cacheRegistry: [String: Any] = [:]
    
    /// Retrieves or creates a shared memory cache for a given key-value pair type.
    ///
    /// If a cache already exists for the given key-value types, it returns the existing instance.
    /// Otherwise, it creates a new cache, registers it, and returns it.
    ///
    /// - Returns: A shared `MemoryCache<Key, Value>` instance.
    public static func getCache<Key: Hashable, Value>() -> MemoryCache<Key, Value> {
        let cacheKey = generateCacheKey(for: Key.self, valueType: Value.self)
        
        if let existingCache = cacheRegistry[cacheKey] as? MemoryCache<Key, Value> {
            return existingCache
        }
        
        let newCache = MemoryCache<Key, Value>()
        cacheRegistry[cacheKey] = newCache
        return newCache
    }
    
    /// Generates a unique key for storing cache instances based on key and value types.
    ///
    /// - Parameters:
    ///   - keyType: The key type for the cache.
    ///   - valueType: The value type for the cache.
    /// - Returns: A unique string representation of the cache key.
    static private func generateCacheKey<Key, Value>(
        for keyType: Key.Type,
        valueType: Value.Type
    ) -> String {
        "\(keyType)-\(valueType)"
    }
}
