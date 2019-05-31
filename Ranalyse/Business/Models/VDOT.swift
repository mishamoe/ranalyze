//
//  VDOT.swift
//  Ranalyse
//
//  Created by Mykhailo Moiseienko on 5/29/19.
//  Copyright © 2019 Mykhailo Moiseienko. All rights reserved.
//

import Foundation

struct VDOT {
    let value: Double
    let results: [KnownDistance: Duration]
    
    var date: Date?
    
    var formattedValue: String {
        return String(format: "%.1f", value)
    }
    
    init(value: Double, results: [KnownDistance: Duration]) {
        self.value = value
        self.results = results
    }
    
    init?(distance: KnownDistance, duration: Duration) {
        if let vdot = VDOTDatabase.accurateVDOT(distance: distance, duration: duration) {
            self = vdot
        } else {
            return nil
        }
    }
}

extension VDOT: Comparable {
    static func == (lhs: VDOT, rhs: VDOT) -> Bool {
        return lhs.value == rhs.value
    }
    
    static func < (lhs: VDOT, rhs: VDOT) -> Bool {
        return lhs.value < rhs.value
    }
}
