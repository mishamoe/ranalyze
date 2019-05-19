//
//  Double+extensions.swift
//  Ranalyse
//
//  Created by Mykhailo Moiseienko on 5/11/19.
//  Copyright © 2019 Mykhailo Moiseienko. All rights reserved.
//

import Foundation

extension Double {
    var durationString: String {
        let time = NSInteger(self)
        
        let seconds = time % 60
        let minutes = (time / 60) % 60
        let hours = (time / 3600)
        
        return String(format: "%0.2d:%0.2d:%0.2d", hours, minutes, seconds)
    }

    var paceString: String {
        let minutes = Int(floor(self))
        let seconds = Int((self - floor(self)) * 60)
        
        return String(format: "%d:%02d", minutes, seconds)
    }
}

