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
    public let distance: Double
    
    /// Total duration in seconds
    public let duration: TimeInterval
    
    /// Cumulative Elevation Gain (in meters)
    public let cumulativeElevationGain: Double
    
    /// Minimal heart rate in BPM (beats per minute)
    public let minHeartRate: Int?
    
    /// Maximal heart rate in BPM (beats per minute)
    public let maxHeartRate: Int?
    
    /// Average heart rate in BPM (beats per minute)
    public let averageHeartRate: Int?
    
    /// Total Elevation Loss in meters
//    let totalElevationLoss: Int
    
    /// Relative Effort
    public let relativeEffort: Double
    
    
    /// 1 kilometer splits
    lazy var splits: [Split] = {
        return generateSplits()
    }()
    
    public init(gpx: GPXRoot) {
        self.gpx = gpx
        self.allPoints = gpx.tracks.flatMap {
            $0.tracksegments.flatMap {
                $0.trackpoints
            }
        }
        
        var totalDistance = 0.0
        var totalDuration = 0.0
        var cumulativeElevationGain = 0.0
        var minHeartRate = Int.max
        var maxHeartRate = Int.min
        
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
            }
            
            print(String(format:"\t+%.2f m | +%.0f s", distance, duration))
            print(String(format:"%.2f m | %@\n", totalDistance, Formatter.duration(totalDuration)))
        }
        
        self.name = gpx.tracks.first?.name
        self.date = gpx.metadata?.time
        
        self.distance = totalDistance
        self.duration = totalDuration
        self.cumulativeElevationGain = cumulativeElevationGain
        
        self.minHeartRate = minHeartRate == Int.max ? nil : minHeartRate
        self.maxHeartRate = maxHeartRate == Int.min ? nil : maxHeartRate
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
    
    func generateSplits() -> [Split] {
        var splits = [Split]()
        var currentSplit: Split!
        
        for i in 1..<allPoints.count {
            let previousPoint = allPoints[i - 1]
            let currentPoint = allPoints[i]
            
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
            
            if currentSplit.distance >= 1_000.0 || currentPoint == allPoints.last {
                print(String(format: "%d | %.2f m | %@ | %.2f km/h | %@", currentSplit.index, currentSplit.distance, Formatter.duration(currentSplit.time), currentSplit.speed, Formatter.pace(currentSplit.pace)))
                
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
