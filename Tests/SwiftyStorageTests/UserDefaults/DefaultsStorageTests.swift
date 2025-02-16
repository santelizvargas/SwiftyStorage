//
//  DefaultsStorageIntegrationTests.swift
//  SwiftyStorageTests
//
//  Created by Steven Santeliz on 16/2/25.
//

import XCTest
import SwiftyStorage

final class DefaultsStorageTests: XCTestCase {
    private let key = "username"
    private let initialValue = "Brandon"
    private let updatedValue = "Steven"
    
    override func setUp() {
        super.setUp()
        UserDefaults.standard.removeObject(forKey: key)
    }
    
    override func tearDown() {
        UserDefaults.standard.removeObject(forKey: key)
        super.tearDown()
    }
    
    func test_defaultValueIsReturned() {
        // Given
        @DefaultsStorage(key, defaultValue: initialValue)
        var username: String
        
        // Then
        XCTAssertEqual(username, initialValue, "Expected default value to be \(initialValue), but got \(username)")
    }
    
    func test_canStoreAndRetrieveNewValue() {
        // Given
        @DefaultsStorage(key, defaultValue: "")
        var username: String
        
        // When
        username = initialValue
        
        // Then
        XCTAssertEqual(username, initialValue, "Expected stored value to be \(initialValue), but got \(username)")
    }
    
    func test_canUpdateExistingValue() {
        // Given
        @DefaultsStorage(key)
        var username: String?
        
        // When: Set initial value
        username = initialValue
        
        // Then
        XCTAssertEqual(username, initialValue, "Expected username to be \(initialValue) after first assignment, but got \(String(describing: username))")
        
        // When: Update value
        username = updatedValue
        
        // Then
        XCTAssertEqual(username, updatedValue, "Expected username to be \(updatedValue) after update, but got \(String(describing: username))")
    }
    
    func test_canRemoveValue() {
        // Given
        @DefaultsStorage(key)
        var username: String?
        
        // When: Store a value
        username = initialValue
        
        // Then
        XCTAssertEqual(username, initialValue, "Expected username to be \(initialValue) before deletion, but got \(String(describing: username))")
        
        // When: Remove the value
        username = nil
        
        // Then
        XCTAssertNil(username, "Expected username to be nil after deletion, but got \(String(describing: username))")
    }
}
