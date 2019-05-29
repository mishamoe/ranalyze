//
//  Formatter.swift
//  Ranalyse
//
//  Created by Mykhailo Moiseienko on 5/20/19.
//  Copyright © 2019 Mykhailo Moiseienko. All rights reserved.
//

import Foundation

struct Formatter {
    
    static func date(_ value: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, HH:mm"
        
        return formatter.string(from: value)
    }
    
    static func distance(valueInMeters: Distance) -> String {
        return String(format: "%.2f km", valueInMeters / 1000)
    }
    
    static func distance(valueInKilometers: Distance) -> String {
        return String(format: "%.2f km", valueInKilometers)
    }
    
    static func duration(_ value: Duration) -> String {
        let time = Int(value)
        
        let seconds = time % 60
        let minutes = (time / 60) % 60
        let hours = (time / 3600)
        
        if hours > 0 {
            return String(format: "%d:%0.2d:%0.2d", hours, minutes, seconds)
        } else {
            return String(format: "%d:%0.2d", minutes, seconds)
        }
    }
    
    static func pace(_ value: Pace) -> String {
        let minutes = Int(floor(value))
        let seconds = Int((value - floor(value)) * 60)
        
        return String(format: "%d'%02d''", minutes, seconds)
    }
    
    static func heartRate(_ value: BPM) -> String {
        return "\(value) bpm"
    }
    
    static func cumulativeElevationGain(_ value: Elevation) -> String {
        return String(format: "+%.0f m", round(value))
    }
    
    static func range(_ value: ClosedRange<BPM>) -> String {
        return "\(value.lowerBound) - \(value.upperBound)"
    }
    
    static func lessThanUpperBound(_ value: ClosedRange<BPM>) -> String {
        return "< \(value.upperBound)"
    }
    
    static func moreThanLowerBound(_ value: ClosedRange<BPM>) -> String {
        return "> \(value.lowerBound)"
    }
}
