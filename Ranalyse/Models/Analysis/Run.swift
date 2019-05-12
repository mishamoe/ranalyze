//
//  Run.swift
//  Ranalyse
//
//  Created by Mykhailo Moiseienko on 5/11/19.
//  Copyright © 2019 Mykhailo Moiseienko. All rights reserved.
//

import Foundation
import CoreGPX

struct Run {
    let gpx: GPXRoot
    
    /// Name of the run
    let name: String?
    
    /// Date of the run
    let date: Date?
    
    /// Total distance in meters
    let distance: Double
    
    /// Total duration in seconds
    let duration: TimeInterval
    
    /// Minimal heart rate in BPM (beats per minute)
    let minHeartRate: Int
    
    /// Maximal heart rate in BPM (beats per minute)
    let maxHeartRate: Int
    
    /// Average heart rate in BPM (beats per minute)
    let averageHeartRate: Int
    
    /// Cumulative Elevation Gain in meters
    let cumulativeElevationGain: Double
    
    /// Total Elevation Loss in meters
//    let totalElevationLoss: Int
    
    init(gpx: GPXRoot) {
        self.gpx = gpx
        
        name = gpx.tracks.first?.name
        date = gpx.metadata?.time
        
        // Distance
        let distanceCalculator = DistanceCalculator()
        distance = distanceCalculator.totalDistance(forGPX: gpx)
        
        // Duration
        let durationCalculator = DurationCalculator()
        duration = durationCalculator.totalDuration(forGPX: gpx)
        
        // Heart Rate
        let heartRateCalculator = HeartRateCalculator()
        minHeartRate = heartRateCalculator.minHeartRate(forGPX: gpx)
        maxHeartRate = heartRateCalculator.maxHeartRate(forGPX: gpx)
        averageHeartRate = heartRateCalculator.averageHeartRate(forGPX: gpx)
        
        // Elevation
        let elevationCalculator = ElevationCalculator()
        cumulativeElevationGain = elevationCalculator.cumulativeElevationGain(forGPX: gpx)
//        totalElevationLoss = elevationCalculator.totalElevationLoss(forGPX: gpx)
    }
}

extension Run {
    static func run(fromGPXFile fileName: String) -> Run? {
        guard let inputURL = Bundle.main.url(forResource: fileName, withExtension: "gpx") else { return nil }
        let parser = GPXParser(withURL: inputURL)
        guard let gpx = parser?.parsedData() else { return nil }
        return Run(gpx: gpx)
    }
}
