//
//  HeartRateZoneTest.swift
//  RanalyseTests
//
//  Created by Mykhailo Moiseienko on 5/22/19.
//  Copyright © 2019 Mykhailo Moiseienko. All rights reserved.
//

import XCTest
@testable import Ranalyse

class HeartRateZoneTest: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testEnduranceZone() {
        let maxHeartRate = 185
        let range = HeartRateZone.endurance.range(for: maxHeartRate)
        
        XCTAssertEqual(range, 92...111)
    }

    func testModerateZone() {
        let maxHeartRate = 185
        let range = HeartRateZone.moderate.range(for: maxHeartRate)
        
        XCTAssertEqual(range, 111...129)
    }
    
    func testTempoZone() {
        let maxHeartRate = 185
        let range = HeartRateZone.tempo.range(for: maxHeartRate)
        
        XCTAssertEqual(range, 129...148)
    }
    
    func testThresholdZone() {
        let maxHeartRate = 185
        let range = HeartRateZone.threshold.range(for: maxHeartRate)
        
        XCTAssertEqual(range, 148...166)
    }
    
    func testAnaerobicZone() {
        let maxHeartRate = 185
        let range = HeartRateZone.anaerobic.range(for: maxHeartRate)
        
        XCTAssertEqual(range, 166...185)
    }
    
    func testZoneForHeartRate() {
        XCTAssertEqual(HeartRateZone.zone(of: Int.min, forMaxHeartRate: 185), .endurance)
        XCTAssertEqual(HeartRateZone.zone(of: 0, forMaxHeartRate: 185), .endurance)
        XCTAssertEqual(HeartRateZone.zone(of: 92, forMaxHeartRate: 185), .endurance)
        XCTAssertEqual(HeartRateZone.zone(of: 100, forMaxHeartRate: 185), .endurance)
        XCTAssertEqual(HeartRateZone.zone(of: 111, forMaxHeartRate: 185), .endurance)
        
        XCTAssertEqual(HeartRateZone.zone(of: 120, forMaxHeartRate: 185), .moderate)
        XCTAssertEqual(HeartRateZone.zone(of: 129, forMaxHeartRate: 185), .moderate)
        
        XCTAssertEqual(HeartRateZone.zone(of: 130, forMaxHeartRate: 185), .tempo)
        XCTAssertEqual(HeartRateZone.zone(of: 148, forMaxHeartRate: 185), .tempo)
        
        XCTAssertEqual(HeartRateZone.zone(of: 150, forMaxHeartRate: 185), .threshold)
        XCTAssertEqual(HeartRateZone.zone(of: 166, forMaxHeartRate: 185), .threshold)
        
        XCTAssertEqual(HeartRateZone.zone(of: 167, forMaxHeartRate: 185), .anaerobic)
        XCTAssertEqual(HeartRateZone.zone(of: 185, forMaxHeartRate: 185), .anaerobic)
        XCTAssertEqual(HeartRateZone.zone(of: 200, forMaxHeartRate: 185), .anaerobic)
        XCTAssertEqual(HeartRateZone.zone(of: Int.max, forMaxHeartRate: 185), .anaerobic)
    }

}
