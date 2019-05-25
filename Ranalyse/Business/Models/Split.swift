//
//  Split.swift
//  Ranalyse
//
//  Created by Mykhailo Moiseienko on 5/19/19.
//  Copyright © 2019 Mykhailo Moiseienko. All rights reserved.
//

import Foundation
import CoreGPX

public class Split {
    public let index: Int
    
    /// Distance (in meters)
    public var distance: Double
    
    /// Time (in seconds)
    public var time: TimeInterval
    
    /// Speed (in kilometers per hour)
    public var speed: Double {
        return distance / time * 3.6
    }
    
    /// Pace (in minutes per kilometer)
    public var pace: Pace {
        return 60.0 / speed
    }
    
    /// Average heart rate in BPM (beats per minute)
    public var averageHeartRate: Int?
    
    /// Cumulative Elevation Gain (in meters)
    public var cumulativeElevationGain: Double
    
    var points: [GPXTrackPoint]
    
    public init(index: Int) {
        self.index = index
        
        distance = 0.0
        time = 0.0
        averageHeartRate = nil
        cumulativeElevationGain = 0.0
        points = []
    }
    
    public func addPoint(_ point: GPXTrackPoint) {
        points.append(point)
    }
}

extension Split {
    func initFromPoints() {
        // Distance
        distance = DistanceCalculator.totalDistance(forPoints: points)
        
        // Time
        time = DurationCalculator.totalDuration(forPoints: points)
        
        // Average Heart Rate
        averageHeartRate = HeartRateCalculator.averageHeartRate(forPoints: points)
        
        // Cumulative Elevation Gain
        cumulativeElevationGain = ElevationCalculator.cumulativeElevationGain(forPoints: points)
    }
}

extension Split: Hashable {
    public static func == (lhs: Split, rhs: Split) -> Bool {
        return lhs.index == rhs.index
    }
    
    public var hashValue: Int {
        return index.hashValue
    }
}
