//
//  KnownDistance.swift
//  Ranalyse
//
//  Created by Mykhailo Moiseienko on 5/29/19.
//  Copyright © 2019 Mykhailo Moiseienko. All rights reserved.
//

import Foundation

enum KnownDistance: Distance {
    case distance1500 = 1_500.0
    case distance3000 = 3_000.0
    case distance5000 = 5_000.0
    case distance10000 = 10_000.0
    case distance15000 = 15_000.0
    case distanceHalfMarathon = 21_097.5
    case distanceMarathon = 42_195.0
    
    static let all = [distance1500, distance3000, distance5000, distance10000, distance15000, distanceHalfMarathon, distanceMarathon]
    
    static func nearestDistance(to distance: Distance) -> KnownDistance? {
        switch distance {
        case 1_500.0..<3_000.0:
            return distance1500
        case 3_000.0..<5_000.0:
            return distance3000
        case 5_000.0..<10_000.0:
            return distance5000
        case 10_000.0..<15_000.0:
            return distance10000
        case 15_000.0..<21_097.5:
            return distance15000
        case 21_097.5..<42_195.0:
            return distanceHalfMarathon
        case 42_195.0..<50_000_000.0:
            return distanceMarathon
        default:
            return nil
        }
    }
    
    var formattedValue: String {
        switch self {
        case .distance1500:
            return "1.5 km"
        case .distance3000:
            return "3 km"
        case .distance5000:
            return "5 km"
        case .distance10000:
            return "10 km"
        case .distance15000:
            return "15 km"
        case .distanceHalfMarathon:
            return "Half marathon (21.0975 km)"
        case .distanceMarathon:
            return "Marathon (42.195 km)"
        }
    }
}
