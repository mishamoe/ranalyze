//
//  Results.swift
//  Ranalyse
//
//  Created by Mykhailo Moiseienko on 5/25/19.
//  Copyright © 2019 Mykhailo Moiseienko. All rights reserved.
//

import Foundation

struct Results {
    var averagePace: Pace?
    var averageHeartRate: BPM?
    var maxHeartRate: BPM?
    
    var farthestRun: Distance?
    var longestRun: Duration?
    
    var fastestOneKilometer: Pace?
    var fastestFiveKilometers: Pace?
    var fastestTenKilometer: Pace?
    var fastestHalfMarathon: Pace?
    var fastestMarathon: Pace?
    
    // MARK: - Initializer
    
    init() { }
}

// MARK: - Formatted strings
extension Results {
    var formattedAveragePace: String {
        if let averagePace = averagePace {
            return Formatter.pace(averagePace)
        } else {
            return NSLocalizedString("N/A", comment: "")
        }
    }
    
    var formattedAverageHeartRate: String {
        if let averageHeartRate = averageHeartRate {
            return Formatter.heartRate(averageHeartRate)
        } else {
            return NSLocalizedString("N/A", comment: "")
        }
    }
    
    var formattedMaxHeartRate: String {
        if let maxHeartRate = maxHeartRate {
            return Formatter.heartRate(maxHeartRate)
        } else {
            return NSLocalizedString("N/A", comment: "")
        }
    }
    
    var formattedFarthestRun: String {
        if let farthestRun = farthestRun {
            return Formatter.distance(valueInMeters: farthestRun)
        } else {
            return NSLocalizedString("N/A", comment: "")
        }
    }
    
    var formattedLongestRun: String {
        if let longestRun = longestRun {
            return Formatter.duration(longestRun)
        } else {
            return NSLocalizedString("N/A", comment: "")
        }
    }
    
    var formattedFastestOneKilometer: String {
        if let fastestOneKilometer = fastestOneKilometer {
            return Formatter.pace(fastestOneKilometer)
        } else {
            return NSLocalizedString("N/A", comment: "")
        }
    }
    
    var formattedFastestFiveKilometers: String {
        if let fastestFiveKilometers = fastestFiveKilometers {
            return Formatter.pace(fastestFiveKilometers)
        } else {
            return NSLocalizedString("N/A", comment: "")
        }
    }
    
    var formattedFastestTenKilometer: String {
        if let fastestTenKilometer = fastestTenKilometer {
            return Formatter.pace(fastestTenKilometer)
        } else {
            return NSLocalizedString("N/A", comment: "")
        }
    }
    
    var formattedFastestHalfMarathon: String {
        if let fastestHalfMarathon = fastestHalfMarathon {
            return Formatter.pace(fastestHalfMarathon)
        } else {
            return NSLocalizedString("N/A", comment: "")
        }
    }
    
    var formattedFastestMarathon: String {
        if let fastestHalfMarathon = fastestHalfMarathon {
            return Formatter.pace(fastestHalfMarathon)
        } else {
            return NSLocalizedString("N/A", comment: "")
        }
    }
}
