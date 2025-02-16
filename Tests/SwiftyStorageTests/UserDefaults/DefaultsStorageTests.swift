//
//  DefaultsStorageIntegrationTests.swift
//  SwiftyStorageTests
//
//  Created by Steven Santeliz on 16/2/25.
//

import XCTest
import SwiftyStorage

final class DefaultsStorageTests: XCTestCase {
    private let key = "storedKey"
    private let initialValue = "InitialValue"
    private let updatedValue = "UpdatedValue"
    
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
        var storedValue: String
        
        // Then
        XCTAssertEqual(storedValue, initialValue, "Expected default value to be \(initialValue), but got \(storedValue)")
    }
    
    func test_canStoreAndRetrieveNewValue() {
        // Given
        @DefaultsStorage(key, defaultValue: "")
        var storedValue: String
        
        // When
        storedValue = initialValue
        
        // Then
        XCTAssertEqual(storedValue, initialValue, "Expected stored value to be \(initialValue), but got \(storedValue)")
    }
    
    func test_canUpdateExistingValue() {
        // Given
        @DefaultsStorage(key)
        var storedValue: String?
        
        // When: Set initial value
        storedValue = initialValue
        
        // Then
        XCTAssertEqual(storedValue, initialValue, "Expected storedValue to be \(initialValue) after first assignment, but got \(String(describing: storedValue))")
        
        // When: Update value
        storedValue = updatedValue
        
        // Then
        XCTAssertEqual(storedValue, updatedValue, "Expected storedValue to be \(updatedValue) after update, but got \(String(describing: storedValue))")
    }
    
    func test_canRemoveValue() {
        // Given
        @DefaultsStorage(key)
        var storedValue: String?
        
        // When: Store a value
        storedValue = initialValue
        
        // Then
        XCTAssertEqual(storedValue, initialValue, "Expected storedValue to be \(initialValue) before deletion, but got \(String(describing: storedValue))")
        
        // When: Remove the value
        storedValue = nil
        
        // Then
        XCTAssertNil(storedValue, "Expected storedValue to be nil after deletion, but got \(String(describing: storedValue))")
    }
}
