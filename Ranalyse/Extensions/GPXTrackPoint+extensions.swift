//
//  GPXTrackPoint+extensions.swift
//  Ranalyse
//
//  Created by Mykhailo Moiseienko on 5/12/19.
//  Copyright © 2019 Mykhailo Moiseienko. All rights reserved.
//

import Foundation
import CoreGPX

extension GPXTrackPoint {
    var heartRate: Int? {
        if let dictionary = dictionary, let heartRate = dictionary["gpxtpx:hr"] {
            return Int(heartRate)
        } else {
            return nil
        }
    }
}
