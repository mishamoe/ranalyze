//
//  DurationCalculator.swift
//  Ranalyse
//
//  Created by Mykhailo Moiseienko on 5/11/19.
//  Copyright © 2019 Mykhailo Moiseienko. All rights reserved.
//

import Foundation
import CoreGPX

class DurationCalculator {
    func totalDuration(forGPX gpx: GPXRoot) -> Duration {
        var totalDuration = 0.0
        for track in gpx.tracks {
            totalDuration += self.totalDuration(forTrack: track)
        }
        return totalDuration
    }
    
    func totalDuration(forTrack track: GPXTrack) -> Duration {
        var totalDuration = 0.0
        for trackSegment in track.tracksegments {
            totalDuration += self.totalDuration(forTrackSegment: trackSegment)
        }
        return totalDuration
    }
    
    func totalDuration(forTrackSegment trackSegment: GPXTrackSegment) -> Duration {
        return DurationCalculator.totalDuration(forPoints: trackSegment.trackpoints)
    }
    
    class func totalDuration(forPoints points: [GPXTrackPoint]) -> Duration {
        var totalDuration = 0.0
        for i in 1..<points.count {
            let point1 = points[i - 1]
            let point2 = points[i]
            
            let timeInterval = DurationCalculator.timeIntervalBetweenPoints(point1: point1, point2: point2)
            totalDuration += timeInterval
        }
        
        return totalDuration
    }
    
    class func timeIntervalBetweenPoints(point1: GPXTrackPoint, point2: GPXTrackPoint) -> TimeInterval {
        guard let time1 = point1.time, let time2 = point2.time else { return 0.0 }
        
        return time2.timeIntervalSince(time1)
    }
}
