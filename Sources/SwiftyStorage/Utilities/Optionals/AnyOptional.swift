//
//  AnyOptional.swift
//  SwiftyStorage
//
//  Created by Steven Santeliz on 15/2/25.
//

/// A protocol to detect `nil` values in optional types.
/// This is necessary because Swift does not allow checking if a generic `T` is `nil`
/// unless it is explicitly an `Optional<T>`.
///
/// This enables checking if `wrappedValue` is `nil`.
public protocol AnyOptional {
    /// Indicates whether the optional value is `nil`.
    var isNil: Bool { get }
}

/// Extension that conforms `Optional` to `AnyOptional`,
/// allowing detection of `nil` values in generics.
extension Optional: AnyOptional {
    public var isNil: Bool { return self == nil }
}
