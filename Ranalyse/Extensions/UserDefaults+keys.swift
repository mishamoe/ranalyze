//
//  UserDefaults+keys.swift
//  Ranalyse
//
//  Created by Mykhailo Moiseienko on 5/21/19.
//  Copyright © 2019 Mykhailo Moiseienko. All rights reserved.
//

import Foundation

//let maxHeartRate



extension UserDefaults {
    public enum Key: String {
        case maxHeartRate
    }
    
    public static func get<T>(key: Key) -> T? {
        return UserDefaults.standard.value(forKey: key.rawValue) as? T
    }
    
    public static func set<T>(value: T?, forKey key: Key) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
}
