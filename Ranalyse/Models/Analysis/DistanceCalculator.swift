//
//  DistanceCalculator.swift
//  Ranalyse
//
//  Created by Mykhailo Moiseienko on 5/11/19.
//  Copyright © 2019 Mykhailo Moiseienko. All rights reserved.
//

import Foundation
import CoreGPX

class DistanceCalculator {
    func totalDistance(forGPX gpx: GPXRoot) -> Double {
        var totalDistance = 0.0
        for track in gpx.tracks {
            totalDistance += self.totalDistance(forTrack: track)
        }
        return totalDistance
    }
    
    func totalDistance(forTrack track: GPXTrack) -> Double {
        var totalDistance = 0.0
        for trackSegment in track.tracksegments {
            totalDistance += self.totalDistance(forTrackSegment: trackSegment)
        }
        return totalDistance
    }
    
    func totalDistance(forTrackSegment trackSegment: GPXTrackSegment) -> Double {
        var totalDistance = 0.0
        for i in 1..<trackSegment.trackpoints.count {
            let point1 = trackSegment.trackpoints[i - 1]
            let point2 = trackSegment.trackpoints[i]
            
            let distance = DistanceCalculator.distanceBetweenPoints(point1: point1, point2: point2)
            totalDistance += distance
        }
        
        return totalDistance
    }
    
    /// Calculate Geodesic Distance with Hubeny Formula
    class func distanceBetweenPoints(point1: GPXTrackPoint, point2: GPXTrackPoint) -> Double {
        let lat1 = point1.latitude ?? 0.0
        let lon1 = point1.longitude ?? 0.0
        let lat2 = point2.latitude ?? 0.0
        let lon2 = point2.longitude ?? 0.0
        
        let a = 6378137.0
        let b = 6356752.314245
        let f2 = b * b / (a * a)
        let e2 = 1.0 - f2
        
        let degree = Double.pi / 180.0
        
        let latdiff = (lat1 - lat2) * degree
        let londiff = (lon1 - lon2) * degree
        let latave = 0.5 * (lat1 + lat2) * degree
        let sinlatave = sin(latave)
        let coslatave = cos(latave)
        let w2 = 1.0 - sinlatave * sinlatave * e2
        let w = sqrt(w2)
        let meridian = a * f2 / (w2 * w)
        let n = a / w
        
        return sqrt(
            latdiff * latdiff * meridian * meridian +
                londiff * londiff * n * n * coslatave * coslatave
        )
    }
}
