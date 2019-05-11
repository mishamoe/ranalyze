//
//  DistanceCalculatorTest.swift
//  RanalyseTests
//
//  Created by Mykhailo Moiseienko on 5/11/19.
//  Copyright © 2019 Mykhailo Moiseienko. All rights reserved.
//

import XCTest
@testable import Ranalyse

class DistanceCalculatorTest: XCTestCase {

    let calculator = DistanceCalculator()
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDegreeToRadian() {
        let latitude = 50.3786880
        let longitude = 30.4794290
        
        let latitudeRadians = calculator.degreeToRadian(latitude)
        let longitudeRadians = calculator.degreeToRadian(longitude)
        
        XCTAssertEqual(latitudeRadians.rounded(toPlaces: 12), 0.879273978435)
        XCTAssertEqual(longitudeRadians.rounded(toPlaces: 12), 0.531966390178)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
