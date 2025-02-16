//
//  UserDefaultsStorageTests.swift
//  SwiftyStorage
//
//  Created by Steven Santeliz on 16/2/25.
//

import XCTest
@testable import SwiftyStorage

final class UserDefaultsStorageTests: XCTestCase {
    private let storedKey = "storedKey"
    private var storage: StorageProtocol!
    
    override func setUp() {
        super.setUp()
        storage = UserDefaultsStorage()
        UserDefaults.standard.removeObject(forKey: storedKey)
    }
    
    override func tearDown() {
        UserDefaults.standard.removeObject(forKey: storedKey)
        storage = nil
        super.tearDown()
    }
    
    func test_setNewValue() {
        // Given
        let storedValue = "InitialValue"
        
        // When
        storage.setValue(storedValue, forKey: storedKey)
        
        // Then
        let retrievedValue: String? = storage.getValue(forKey: storedKey)
        XCTAssertEqual(retrievedValue, storedValue, "Expected to retrieve '\(storedValue)', but got '\(String(describing: retrievedValue))'")
    }
    
    func test_updateExistingValue() {
        // Given
        let initialValue = "InitialValue"
        let updatedValue = "UpdatedValue"
        
        // When: Store initial value
        storage.setValue(initialValue, forKey: storedKey)
        
        // Then
        let retrievedInitialValue: String? = storage.getValue(forKey: storedKey)
        XCTAssertEqual(retrievedInitialValue, initialValue, "Expected initial value to be '\(initialValue)', but got '\(String(describing: retrievedInitialValue))'")
        
        // When: Update value
        storage.setValue(updatedValue, forKey: storedKey)
        
        // Then
        let retrievedUpdatedValue: String? = storage.getValue(forKey: storedKey)
        XCTAssertEqual(retrievedUpdatedValue, updatedValue, "Expected updated value to be '\(updatedValue)', but got '\(String(describing: retrievedUpdatedValue))'")
    }
    
    func test_removeExistingValue() {
        // Given
        let storedValue = "InitialValue"
        
        // When: Store value
        storage.setValue(storedValue, forKey: storedKey)
        
        // Then
        let retrievedValue: String? = storage.getValue(forKey: storedKey)
        XCTAssertEqual(retrievedValue, storedValue, "Expected value to be '\(storedValue)' before removal, but got '\(String(describing: retrievedValue))'")
        
        // When: Remove value
        storage.removeValue(forKey: storedKey)
        
        // Then
        let removedValue: String? = storage.getValue(forKey: storedKey)
        XCTAssertNil(removedValue, "Expected value to be nil after removal, but got '\(String(describing: removedValue))'")
    }
}
