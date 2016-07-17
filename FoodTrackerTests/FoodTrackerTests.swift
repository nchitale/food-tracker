//
//  FoodTrackerTests.swift
//  FoodTrackerTests
//
//  Created by Nandini  on 6/26/16.
//
//

import UIKit
import XCTest
@testable import FoodTracker

class FoodTrackerTests: XCTestCase {
    
    // MARK: FoodTracker Tests
    
    // Tests to confirm that the Card initializer returns when no name or a negative rating is provided.
    func testCardInitialization() {
        
        // Success case.
        let potentialItem = Card(name: "Newest card", photo: nil, rating: 5)
        XCTAssertNotNil(potentialItem)
        
        // Failure cases.
        let noName = Card(name: "", photo: nil, rating: 0)
        XCTAssertNil(noName, "Empty name is invalid")
        
        let badRating = Card(name: "Really bad rating", photo: nil, rating: -1)
        XCTAssertNil(badRating, "Negative ratings are invalid, be positive")
    }
}
