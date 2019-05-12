//
//  HeartRateCalculator.swift
//  Ranalyse
//
//  Created by Mykhailo Moiseienko on 5/11/19.
//  Copyright © 2019 Mykhailo Moiseienko. All rights reserved.
//

import Foundation
import CoreGPX

class HeartRateCalculator {
    
    // MARK: - Minimal Heart Rate
    
    func minHeartRate(forGPX gpx: GPXRoot) -> Int {
        var min = Int.max
        for track in gpx.tracks {
            let heartRate = minHeartRate(forTrack: track)
            if  heartRate < min {
                min = heartRate
            }
        }
        return min
    }
    
    func minHeartRate(forTrack track: GPXTrack) -> Int {
        var min = Int.max
        for tracksegment in track.tracksegments {
            let heartRate = minHeartRate(forTrackSegment: tracksegment)
            if  heartRate < min {
                min = heartRate
            }
        }
        return min
    }
    
    func minHeartRate(forTrackSegment trackSegment: GPXTrackSegment) -> Int {
        var min = Int.max
        for point in trackSegment.trackpoints {
            let heartRate = point.heartRate ?? 0
            if  heartRate < min {
                min = heartRate
            }
        }
        return min
    }
    
    // MARK: - Maximal Heart Rate
    
    func maxHeartRate(forGPX gpx: GPXRoot) -> Int {
        var max = Int.min
        for track in gpx.tracks {
            let heartRate = maxHeartRate(forTrack: track)
            if  heartRate > max {
                max = heartRate
            }
        }
        return max
    }
    
    func maxHeartRate(forTrack track: GPXTrack) -> Int {
        var max = Int.min
        for tracksegment in track.tracksegments {
            let heartRate = maxHeartRate(forTrackSegment: tracksegment)
            if  heartRate > max {
                max = heartRate
            }
        }
        return max
    }
    
    func maxHeartRate(forTrackSegment trackSegment: GPXTrackSegment) -> Int {
        var max = Int.min
        for point in trackSegment.trackpoints {
            let heartRate = point.heartRate ?? 0
            if  heartRate > max {
                max = heartRate
            }
        }
        return max
    }
    
    // MARK: - Maximal Heart Rate
    
    func averageHeartRate(forGPX gpx: GPXRoot) -> Int {
        let heartRateArray = gpx.tracks.map { averageHeartRate(forTrack: $0) }
        let sum = heartRateArray.reduce(0, +)
        return sum / heartRateArray.count
    }
    
    func averageHeartRate(forTrack track: GPXTrack) -> Int {
        let heartRateArray = track.tracksegments.map { averageHeartRate(forTrackSegment: $0) }
        let sum = heartRateArray.reduce(0, +)
        return sum / heartRateArray.count
    }
    
    func averageHeartRate(forTrackSegment trackSegment: GPXTrackSegment) -> Int {
        let heartRateArray = trackSegment.trackpoints.compactMap { $0.heartRate }
        let sum = heartRateArray.reduce(0, +)
        return sum / heartRateArray.count
    }
}
