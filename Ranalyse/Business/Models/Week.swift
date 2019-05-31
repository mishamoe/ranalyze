//
//  Week.swift
//  Ranalyse
//
//  Created by Mykhailo Moiseienko on 5/31/19.
//  Copyright © 2019 Mykhailo Moiseienko. All rights reserved.
//

import Foundation

struct Week {
    let startDate: Date
    let endDate: Date
}

// MARK: - Initializers
extension Week {
    init?(date: Date) {
        guard let start = date.startOfWeek, let end = date.endOfWeek else { return nil }
        
        self = Week(startDate: start, endDate: end)
    }
}

// MARK: - Previous & Next weeks
extension Week {
    var previousWeek: Week? {
        guard let previousWeekStartDate = DataStore.calendar.date(byAdding: .day, value: -7, to: startDate),
            let previousWeekEndDate = DataStore.calendar.date(byAdding: .day, value: -7, to: endDate) else { return nil }
        
        return Week(startDate: previousWeekStartDate, endDate: previousWeekEndDate)
    }
    
    var nextWeek: Week? {
        guard let previousWeekStartDate = DataStore.calendar.date(byAdding: .day, value: 7, to: startDate),
            let previousWeekEndDate = DataStore.calendar.date(byAdding: .day, value: 7, to: endDate) else { return nil }
        
        return Week(startDate: previousWeekStartDate, endDate: previousWeekEndDate)
    }
}

extension Week: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(startDate)
        hasher.combine(endDate)
    }
}

// MARK: - Start & End of week for date
extension Date {
    var startOfWeek: Date? {
        let components = DataStore.calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
        guard let monday = DataStore.calendar.date(from: components) else { return nil }
        return monday
    }
    
    var endOfWeek: Date? {
        let components = DataStore.calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
        guard let monday = DataStore.calendar.date(from: components) else { return nil }
        let sunday = DataStore.calendar.date(byAdding: .day, value: 6, to: monday)
        return sunday
    }
}

extension Date {
    var week: Week? {
        return Week(date: self)
    }
}
