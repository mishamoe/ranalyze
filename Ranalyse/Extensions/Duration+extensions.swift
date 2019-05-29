//
//  Duration+extensions.swift
//  Ranalyse
//
//  Created by Mykhailo Moiseienko on 5/29/19.
//  Copyright © 2019 Mykhailo Moiseienko. All rights reserved.
//

import Foundation

extension Duration {
    init(hours: Int, minutes: Int, seconds: Int) {
        self.init(hours * 60 * 60 + minutes * 60 + seconds)
    }
    
    init(minutes: Int, seconds: Int) {
        self.init(minutes * 60 + seconds)
    }
    
    init?(string: String) {
        let components = string.components(separatedBy: ":")
        
        guard components.count == 3,
            let hours = Int(components[0]),
            let minutes = Int(components[1]),
            let seconds = Int(components[2]) else {
                return nil
        }
        
        self.init(hours: hours, minutes: minutes, seconds: seconds)
    }
}
