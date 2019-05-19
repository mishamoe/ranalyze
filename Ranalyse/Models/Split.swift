//
//  Split.swift
//  Ranalyse
//
//  Created by Mykhailo Moiseienko on 5/19/19.
//  Copyright © 2019 Mykhailo Moiseienko. All rights reserved.
//

import Foundation

struct Split {
    let index: Int
    
    /// Distance (in meters)
    var distance: Double
    
    /// Time (in seconds)
    var time: TimeInterval
    
    /// Speed (in kilometers per hour)
    var speed: Double {
        return distance / time * 3.6
    }
    
    /// Pace (in minutes per kilometer)
    var pace: Double {
        return 60.0 / speed
    }
}
