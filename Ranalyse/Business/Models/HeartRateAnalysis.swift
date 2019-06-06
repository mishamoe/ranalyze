//
//  HeartRateAnalysis.swift
//  Ranalyse
//
//  Created by Mykhailo Moiseienko on 5/22/19.
//  Copyright © 2019 Mykhailo Moiseienko. All rights reserved.
//

import Foundation

public struct HeartRateAnalysis {
    public let maxHeartRate: Int
    
    var timeIntervals: [HeartRateZone: TimeInterval] = [
        .endurance: 0.0,
        .moderate: 0.0,
        .tempo: 0.0,
        .threshold: 0.0,
        .anaerobic: 0.0
    ]
    
    init(maxHeartRate: Int) {
        self.maxHeartRate = maxHeartRate
    }
    
    public mutating func addHeartRate(_ heartRate: Int, for timeInterval: TimeInterval) {
        let zone = HeartRateZone.zone(of: heartRate, forMaxHeartRate: maxHeartRate)
        timeIntervals[zone]? += timeInterval
    }
    
    public func timeInterval(for zone: HeartRateZone) -> TimeInterval {
        return timeIntervals[zone] ?? 0.0
    }
    
    public func percentage(of zone: HeartRateZone) -> Double {
        let totalTime = timeIntervals.values.reduce(0.0, +)
        return timeInterval(for: zone) / totalTime * 100
    }
}

public enum HeartRateZone: Int {
    case endurance  = 1 // і
    case moderate   = 2 // Средняя (НИЗКИЙ УРОВЕНЬ ИНТЕНСИВНОСТИ)
    case tempo      = 3 // Ритмичная (СРЕДНИЙ УРОВЕНЬ ИНТЕНСИВНОСТИ)
    case threshold  = 4 // Пороговая (ИНТЕНСИВНАЯ ТРЕНИРОВКА)
    case anaerobic  = 5 // Анаэробная (МАКСИМУМ)
    
    public static let all = [endurance, moderate, tempo, threshold, anaerobic]
    
    var bounds: ClosedRange<Int> {
        switch self {
        case .endurance:    return 50...60
        case .moderate:     return 60...70
        case .tempo:        return 70...80
        case .threshold:    return 80...90
        case .anaerobic:    return 90...100
        }
    }
    
    var name: String {
        switch self {
        case .endurance:    return NSLocalizedString("Endurance", comment: "")
        case .moderate:     return NSLocalizedString("Moderate", comment: "")
        case .tempo:        return NSLocalizedString("Tempo", comment: "")
        case .threshold:    return NSLocalizedString("Threshold", comment: "")
        case .anaerobic:    return NSLocalizedString("Anaerobic", comment: "")
        }
    }
}

extension HeartRateZone {
    public func range(for maxHeartRate: Int) -> ClosedRange<Int> {
        let lowerBound = maxHeartRate * bounds.lowerBound / 100
        let upperBound = maxHeartRate * bounds.upperBound / 100
        return lowerBound...upperBound
    }
    
    public static func zone(of heartRate: Int, forMaxHeartRate maxHeartRate: Int) -> HeartRateZone {
        switch heartRate {
        case Int.min..<HeartRateZone.endurance.range(for: maxHeartRate).lowerBound,
             HeartRateZone.endurance.range(for: maxHeartRate):
            return .endurance
        case HeartRateZone.moderate.range(for: maxHeartRate):
            return .moderate
        case HeartRateZone.tempo.range(for: maxHeartRate):
            return tempo
        case HeartRateZone.threshold.range(for: maxHeartRate):
            return .threshold
        case HeartRateZone.anaerobic.range(for: maxHeartRate),
             HeartRateZone.anaerobic.range(for: maxHeartRate).upperBound...Int.max:
            return .anaerobic
        default:
            fatalError(NSLocalizedString("Undefined heart rate value provided", comment: ""))
        }
    }
}
