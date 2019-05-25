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
    
    func minHeartRate(forGPX gpx: GPXRoot) -> BPM? {
        var min = BPM.max
        for track in gpx.tracks {
            if let heartRate = minHeartRate(forTrack: track), heartRate < min {
                min = heartRate
            }
        }
        return min == BPM.max ? nil : min
    }
    
    func minHeartRate(forTrack track: GPXTrack) -> BPM? {
        var min = BPM.max
        for tracksegment in track.tracksegments {
            if let heartRate = minHeartRate(forTrackSegment: tracksegment), heartRate < min {
                min = heartRate
            }
        }
        return min == BPM.max ? nil : min
    }
    
    func minHeartRate(forTrackSegment trackSegment: GPXTrackSegment) -> BPM? {
        var min = BPM.max
        for point in trackSegment.trackpoints {
            if let heartRate = point.heartRate, heartRate < min {
                min = heartRate
            }
        }
        return min == BPM.max ? nil : min
    }
    
    // MARK: - Maximal Heart Rate
    
    func maxHeartRate(forGPX gpx: GPXRoot) -> BPM? {
        var max = BPM.min
        for track in gpx.tracks {
            if let heartRate = maxHeartRate(forTrack: track), heartRate > max {
                max = heartRate
            }
        }
        return max == BPM.min ? nil : max
    }
    
    func maxHeartRate(forTrack track: GPXTrack) -> BPM? {
        var max = BPM.min
        for tracksegment in track.tracksegments {
            if let heartRate = maxHeartRate(forTrackSegment: tracksegment), heartRate > max {
                max = heartRate
            }
        }
        return max == BPM.min ? nil : max
    }
    
    func maxHeartRate(forTrackSegment trackSegment: GPXTrackSegment) -> BPM? {
        var max = BPM.min
        for point in trackSegment.trackpoints {
            if let heartRate = point.heartRate, heartRate > max {
                max = heartRate
            }
        }
        return max == BPM.min ? nil : max
    }
    
    // MARK: - Average Heart Rate
    
    func averageHeartRate(forGPX gpx: GPXRoot) -> BPM? {
        let heartRateArray = gpx.tracks.compactMap { averageHeartRate(forTrack: $0) }
        
        guard !heartRateArray.isEmpty else { return nil }
        
        let sum = heartRateArray.reduce(0, +)
        return sum / heartRateArray.count
    }
    
    func averageHeartRate(forTrack track: GPXTrack) -> BPM? {
        let heartRateArray = track.tracksegments.compactMap { averageHeartRate(forTrackSegment: $0) }
        
        guard !heartRateArray.isEmpty else { return nil }
        
        let sum = heartRateArray.reduce(0, +)
        return sum / heartRateArray.count
    }
    
    func averageHeartRate(forTrackSegment trackSegment: GPXTrackSegment) -> BPM? {
        return HeartRateCalculator.averageHeartRate(forPoints: trackSegment.trackpoints)
    }
    
    class func averageHeartRate(forPoints points: [GPXTrackPoint]) -> BPM? {
        let heartRateArray = points.compactMap { $0.heartRate }
        
        guard !heartRateArray.isEmpty else { return nil }
        
        let sum = heartRateArray.reduce(0, +)
        return sum / heartRateArray.count
    }
}
