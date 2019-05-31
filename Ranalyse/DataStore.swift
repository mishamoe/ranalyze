//
//  DataStore.swift
//  Ranalyse
//
//  Created by Mykhailo Moiseienko on 5/21/19.
//  Copyright © 2019 Mykhailo Moiseienko. All rights reserved.
//

import Foundation

class DataStore {
    static let shared = DataStore()
    
    static let calendar: Calendar = {
        var calendar = Calendar.current
        calendar.firstWeekday = 2 // 1 - Sunday, 2 - Monday, ...
        return calendar
    }()
    
    private let dataService = DataService()
    
    private var runs: [Run]?
    
    func getRuns(_ completion: @escaping (Result<[Run], RanalyzeError>) -> Void) {
        dataService.loadRuns { result in
            if case .success(let runs) = result {
                self.runs = runs
            }
            
            completion(result)
        }
    }
    
    func getMaxHeartRate(_ completion: @escaping (Result<BPM, RanalyzeError>) -> Void) {
        guard let runs = runs else {
            getRuns { [weak self] result in
                if case .success = result {
                    self?.getMaxHeartRate(completion)
                } else if case .failure(let error) = result {
                    completion(.failure(error))
                }
            }
            return
        }
        
        completion(
            dataService.findMaxHeartRate(runs: runs)
        )
    }
    
    public func getFastestSplit(_ completion: @escaping (Result<Split, RanalyzeError>) -> Void) {
        guard let runs = runs else {
            getRuns { [weak self] result in
                if case .success = result {
                    self?.getFastestSplit(completion)
                } else if case .failure(let error) = result {
                    completion(.failure(error))
                }
            }
            return
        }
        
        completion(
            dataService.findFastestSplit(runs: runs)
        )
    }
}
