//
//  UserDefaultsStorageTests.swift
//  SwiftyStorage
//
//  Created by Steven Santeliz on 16/2/25.
//

import XCTest
@testable import SwiftyStorage

final class UserDefaultsStorageTests: XCTestCase {
    private let key = "username"
    private var storage: StorageProtocol!
    
    override func setUp() {
        super.setUp()
        storage = UserDefaultsStorage()
        UserDefaults.standard.removeObject(forKey: key)
    }
    
    override func tearDown() {
        UserDefaults.standard.removeObject(forKey: key)
        storage = nil
        super.tearDown()
    }
    
    func test_setNewValue() {
        // Given
        let expectedValue = "Brandon"
        
        // When
        storage.setValue(expectedValue, forKey: key)
        
        // Then
        let retrievedValue: String? = storage.getValue(forKey: key)
        XCTAssertEqual(retrievedValue, expectedValue, "Expected to retrieve '\(expectedValue)', but got '\(String(describing: retrievedValue))'")
    }
    
    func test_updateExistingValue() {
        // Given
        let initialValue = "Brandon"
        let updatedValue = "Steven"
        
        // When: Store initial value
        storage.setValue(initialValue, forKey: key)
        
        // Then
        let retrievedInitialValue: String? = storage.getValue(forKey: key)
        XCTAssertEqual(retrievedInitialValue, initialValue, "Expected initial value to be '\(initialValue)', but got '\(String(describing: retrievedInitialValue))'")
        
        // When: Update value
        storage.setValue(updatedValue, forKey: key)
        
        // Then
        let retrievedUpdatedValue: String? = storage.getValue(forKey: key)
        XCTAssertEqual(retrievedUpdatedValue, updatedValue, "Expected updated value to be '\(updatedValue)', but got '\(String(describing: retrievedUpdatedValue))'")
    }
    
    func test_removeExistingValue() {
        // Given
        let initialValue = "Brandon"
        
        // When: Store value
        storage.setValue(initialValue, forKey: key)
        
        // Then
        let retrievedValue: String? = storage.getValue(forKey: key)
        XCTAssertEqual(retrievedValue, initialValue, "Expected value to be '\(initialValue)' before removal, but got '\(String(describing: retrievedValue))'")
        
        // When: Remove value
        storage.removeValue(forKey: key)
        
        // Then
        let removedValue: String? = storage.getValue(forKey: key)
        XCTAssertNil(removedValue, "Expected value to be nil after removal, but got '\(String(describing: removedValue))'")
    }
}
