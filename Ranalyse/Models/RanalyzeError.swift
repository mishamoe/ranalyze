//
//  RanalyzeError.swift
//  Ranalyse
//
//  Created by Mykhailo Moiseienko on 5/25/19.
//  Copyright © 2019 Mykhailo Moiseienko. All rights reserved.
//

import Foundation

enum RanalyzeError: Error {
    case errorWhenLoadingRuns
    case errorWhenFindingMaxHeartRate
    case errorWhenFindingFastestSplit
    
    var localizedDescription: String {
        switch self {
        case .errorWhenLoadingRuns:
            return NSLocalizedString("An error occurred while loading runs", comment: "")
        case .errorWhenFindingMaxHeartRate:
            return NSLocalizedString("An error occurred while finding maximal heart rate", comment: "")
        case .errorWhenFindingFastestSplit:
            return NSLocalizedString("An error occurred while finding fastest split", comment: "")
        }
    }
}
