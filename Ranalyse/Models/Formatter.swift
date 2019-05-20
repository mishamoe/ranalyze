//
//  Formatter.swift
//  Ranalyse
//
//  Created by Mykhailo Moiseienko on 5/20/19.
//  Copyright © 2019 Mykhailo Moiseienko. All rights reserved.
//

import Foundation

struct Formatter {
    
    static func distance(valueInMeters: Double) -> String {
        return String(format: "%.2f km", valueInMeters / 1000)
    }
    
    static func distance(valueInKilometers: Double) -> String {
        return String(format: "%.2f km", valueInKilometers)
    }
    
    static func duration(_ value: Double) -> String {
        let time = NSInteger(value)
        
        let seconds = time % 60
        let minutes = (time / 60) % 60
        let hours = (time / 3600)
        
        return String(format: "%0.2d:%0.2d:%0.2d", hours, minutes, seconds)
    }
    
    static func pace(_ value: Double) -> String {
        let minutes = Int(floor(value))
        let seconds = Int((value - floor(value)) * 60)
        
        return String(format: "%d'%02d''", minutes, seconds)
    }
    
    static func heartRate(_ value: Int) -> String {
        return "\(value) bpm"
    }
    
    static func cumulativeElevationGain(_ value: Double) -> String {
        return String(format: "+%.0f m", round(value))
    }
}
