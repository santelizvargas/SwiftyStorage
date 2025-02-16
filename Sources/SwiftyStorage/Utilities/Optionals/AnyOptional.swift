//
//  AnyOptional.swift
//  SwiftyStorage
//
//  Created by Steven Santeliz on 15/2/25.
//

/// A protocol for detecting if an optional value is `nil`.
///
/// Used to handle optional values in `DefaultsStorage`, ensuring `nil` values
/// trigger removal from `UserDefaults`.
public protocol AnyOptional {
    /// Indicates whether the optional value is `nil`.
    var isNil: Bool { get }
}

/// Extension that conforms `Optional` to `AnyOptional`,
/// allowing detection of `nil` values in generics.
extension Optional: AnyOptional {
    public var isNil: Bool { return self == nil }
}
