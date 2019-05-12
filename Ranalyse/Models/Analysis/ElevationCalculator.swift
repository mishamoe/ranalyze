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
        var cumulativeElevationGain = 0.0
        for i in 1..<trackSegment.trackpoints.count {
            let point1 = trackSegment.trackpoints[i - 1]
            let point2 = trackSegment.trackpoints[i]
            
            let difference = elevationDifferenceBetweenPoints(point1: point1, point2: point2)
            cumulativeElevationGain += difference > 0 ? difference : 0
        }
        return cumulativeElevationGain
    }
    
    func elevationDifferenceBetweenPoints(point1: GPXTrackPoint, point2: GPXTrackPoint) -> Double {
        return (point2.elevation ?? 0) - (point1.elevation ?? 0)
    }
}
