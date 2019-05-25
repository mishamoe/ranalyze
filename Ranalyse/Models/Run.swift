//
//  Run.swift
//  Ranalyse
//
//  Created by Mykhailo Moiseienko on 5/11/19.
//  Copyright © 2019 Mykhailo Moiseienko. All rights reserved.
//

import Foundation
import CoreGPX

public struct Run {
    
    // MARK: - Internal properties
    
    let gpx: GPXRoot
    let allPoints: [GPXTrackPoint]
    
    // MARK: - Public properties
    
    /// Name of the run
    public let name: String?
    
    /// Date of the run
    public let date: Date?
    
    /// Total distance in meters
    public let distance: Distance
    
    /// Total duration in seconds
    public let duration: Duration
    
    /// Cumulative Elevation Gain (in meters)
    public let cumulativeElevationGain: Elevation
    
    /// Minimal heart rate in BPM (beats per minute)
    public let minHeartRate: BPM?
    
    /// Maximal heart rate in BPM (beats per minute)
    public let maxHeartRate: BPM?
    
    /// Average heart rate in BPM (beats per minute)
    public let averageHeartRate: BPM?
    
    /// Total Elevation Loss in meters
//    let totalElevationLoss: Int
    
    /// Relative Effort
    public let relativeEffort: Double
    
    /// 1 kilometer splits
    public var splits: [Split]
    
    public var heartRateAnalysis: HeartRateAnalysis?
    
    public init(gpx: GPXRoot) {
        self.gpx = gpx
        
        allPoints = gpx.tracks.flatMap {
            $0.tracksegments.flatMap {
                $0.trackpoints
            }
        }
        splits = Run.initSplits(from: allPoints)
        
        if let maxHeartRate: Int = UserDefaults.get(key: .maxHeartRate) {
            heartRateAnalysis = HeartRateAnalysis(maxHeartRate: maxHeartRate)
        }
        
        var totalDistance = 0.0
        var totalDuration = 0.0
        var cumulativeElevationGain = 0.0
        var minHeartRate = BPM.max
        var maxHeartRate = BPM.min
        
        for i in 1..<allPoints.count {
            let previousPoint = allPoints[i - 1]
            let currentPoint = allPoints[i]
            
            let distance = DistanceCalculator.distanceBetweenPoints(point1: previousPoint, point2: currentPoint)
            totalDistance += distance
            
            let duration = DurationCalculator.timeIntervalBetweenPoints(point1: previousPoint, point2: currentPoint)
            totalDuration += duration
            
            let elevation = ElevationCalculator.elevationDifferenceBetweenPoints(point1: previousPoint, point2: currentPoint)
            cumulativeElevationGain += elevation > 0 ? elevation : 0
            
            if let heartRate = currentPoint.heartRate {
                if heartRate < minHeartRate {
                    minHeartRate = heartRate
                }
                if heartRate > maxHeartRate {
                    maxHeartRate = heartRate
                }
                
                heartRateAnalysis?.addHeartRate(heartRate, for: duration)
            }
        }
        
        self.name = gpx.tracks.first?.name
        self.date = gpx.metadata?.time
        
        self.distance = totalDistance
        self.duration = totalDuration
        self.cumulativeElevationGain = cumulativeElevationGain
        
        self.minHeartRate = minHeartRate == BPM.max ? nil : minHeartRate
        self.maxHeartRate = maxHeartRate == BPM.min ? nil : maxHeartRate
        self.averageHeartRate = HeartRateCalculator.averageHeartRate(forPoints: allPoints)
        
        // TODO: Imlpement calculation of relative effort
        self.relativeEffort = 0.0
    }
}

extension Run {
    public static func run(fromGPXFile fileName: String) -> Run? {
        guard let inputURL = Bundle.main.url(forResource: fileName, withExtension: "gpx") else { return nil }
        let parser = GPXParser(withURL: inputURL)
        guard let gpx = parser?.parsedData() else { return nil }
        return Run(gpx: gpx)
    }
    
    static func initSplits(from points: [GPXTrackPoint]) -> [Split] {
        var splits = [Split]()
        var currentSplit: Split!
        
        for i in 1..<points.count {
            let previousPoint = points[i - 1]
            let currentPoint = points[i]
            
            if currentSplit == nil {
                currentSplit = Split(index: splits.endIndex + 1)
            }
            
            // Add point to split
            if i == 1 {
                currentSplit.addPoint(previousPoint)
            }
            currentSplit.addPoint(currentPoint)
            
            // Distance
            let distance = DistanceCalculator.distanceBetweenPoints(point1: previousPoint, point2: currentPoint)
            currentSplit.distance += distance
            
            // Time
            let timeInterval = DurationCalculator.timeIntervalBetweenPoints(point1: previousPoint, point2: currentPoint)
            currentSplit.time += timeInterval
            
            if currentSplit.distance >= 1_000.0 || currentPoint == points.last {
                // Average Heart Rate
                currentSplit.averageHeartRate = HeartRateCalculator
                    .averageHeartRate(forPoints: currentSplit.points)
                
                // Cumulative Elevation Gain
                currentSplit.cumulativeElevationGain = ElevationCalculator
                    .cumulativeElevationGain(forPoints: currentSplit.points)
                
                splits.append(currentSplit)
                currentSplit = nil
            }
        }
        
        return splits
    }
}
