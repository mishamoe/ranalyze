//
//  ElevationCalculator.swift
//  Ranalyse
//
//  Created by Mykhailo Moiseienko on 5/11/19.
//  Copyright © 2019 Mykhailo Moiseienko. All rights reserved.
//

import Foundation
import CoreGPX

class ElevationCalculator {
    func cumulativeElevationGain(forGPX gpx: GPXRoot) -> Double {
        return gpx.tracks
            .map { cumulativeElevationGain(forTrack: $0) }
            .reduce(0.0, +)
    }
    
    func cumulativeElevationGain(forTrack track: GPXTrack) -> Double {
        return track.tracksegments
            .map { cumulativeElevationGain(forTrackSegment: $0) }
            .reduce(0.0, +)
    }
    
    func cumulativeElevationGain(forTrackSegment trackSegment: GPXTrackSegment) -> Double {
        return ElevationCalculator.cumulativeElevationGain(forPoints: trackSegment.trackpoints)
    }
    
    class func cumulativeElevationGain(forPoints points: [GPXTrackPoint]) -> Double {
        var cumulativeElevationGain = 0.0
        for i in 1..<points.count {
            let previousPoint = points[i - 1]
            let currentPoint = points[i]
            
            let difference = ElevationCalculator.elevationDifferenceBetweenPoints(point1: previousPoint, point2: currentPoint)
            cumulativeElevationGain += difference > 0 ? difference : 0
        }
        return cumulativeElevationGain
    }
    
    class func elevationDifferenceBetweenPoints(point1: GPXTrackPoint, point2: GPXTrackPoint) -> Double {
        return (point2.elevation ?? 0) - (point1.elevation ?? 0)
    }
}
