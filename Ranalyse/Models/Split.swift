//
//  Split.swift
//  Ranalyse
//
//  Created by Mykhailo Moiseienko on 5/19/19.
//  Copyright © 2019 Mykhailo Moiseienko. All rights reserved.
//

import Foundation
import CoreGPX

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
    
    /// Average heart rate in BPM (beats per minute)
    var averageHeartRate: Int?
    
    /// Cumulative Elevation Gain (in meters)
    var cumulativeElevationGain: Double
    
    var points: [GPXTrackPoint]
    
    init(index: Int) {
        self.index = index
        
        distance = 0.0
        time = 0.0
        averageHeartRate = nil
        cumulativeElevationGain = 0.0
        points = []
    }
    
    mutating func addPoint(_ point: GPXTrackPoint) {
        points.append(point)
    }
}
