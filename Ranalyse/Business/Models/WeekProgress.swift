//
//  WeekProgress.swift
//  Ranalyse
//
//  Created by Mykhailo Moiseienko on 5/31/19.
//  Copyright © 2019 Mykhailo Moiseienko. All rights reserved.
//

import Foundation

class WeekProgress {
    let week: Week
    var vdots: [VDOT]
    
    var minVDOT: Double {
        return vdots.min()?.value ?? 0.0
    }
    
    var maxVDOT: Double {
        return vdots.max()?.value ?? 0.0
    }
    
    init(week: Week, vdots: [VDOT] = []) {
        self.week = week
        self.vdots = vdots
    }
    
    func addVDOT(_ vdot: VDOT) {
        vdots.append(vdot)
    }
}
