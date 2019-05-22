//
//  HeartRateZone.swift
//  Ranalyse
//
//  Created by Mykhailo Moiseienko on 5/22/19.
//  Copyright © 2019 Mykhailo Moiseienko. All rights reserved.
//

import Foundation

public enum HeartRateZone: Int {
    case endurance  = 1 // Спокойная (ОЧЕНЬ НИЗКАЯ ИНТЕНСИВНОСТЬ)
    case moderate   = 2 // Средняя (НИЗКИЙ УРОВЕНЬ ИНТЕНСИВНОСТИ)
    case tempo      = 3 // Ритмичная (СРЕДНИЙ УРОВЕНЬ ИНТЕНСИВНОСТИ)
    case threshold  = 4 // Пороговая (ИНТЕНСИВНАЯ ТРЕНИРОВКА)
    case anaerobic  = 5 // Анаэробная (МАКСИМУМ)
    
    var bounds: ClosedRange<Int> {
        switch self {
        case .endurance:
            return 50...60
        case .moderate:
            return 60...70
        case .tempo:
            return 70...80
        case .threshold:
            return 80...90
        case .anaerobic:
            return 90...100
        }
    }
    
    public func range(for maxHeartRate: Int) -> ClosedRange<Int> {
        let lowerBound = maxHeartRate * bounds.lowerBound / 100
        let upperBound = maxHeartRate * bounds.upperBound / 100
        return lowerBound...upperBound
    }
    
    static func zone(of heartRate: Int, forMaxHeartRate maxHeartRate: Int) -> HeartRateZone {
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

