//
//  DataStore.swift
//  Ranalyse
//
//  Created by Mykhailo Moiseienko on 5/21/19.
//  Copyright © 2019 Mykhailo Moiseienko. All rights reserved.
//

import Foundation

public class DataStore {
    public static let shared = DataStore()
    
    public var runs: [Run]?
    
    public func loadRuns(_ completion: @escaping (Result<[Run], Error>) -> Void) {
        let gpxFileNames = [
            "Nova_Poshta_Kyiv_Half_Marathon",
            "May_9",
            "May_12",
            "NRC_Saturday_Run"
        ]
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            let runs = gpxFileNames
                .compactMap { Run.run(fromGPXFile: $0) }
                .sorted { ($0.date ?? Date()) > ($1.date ?? Date()) }
            
            self?.runs = runs
            
            DispatchQueue.main.async {
                completion(.success(runs))
            }
        }
    }
    
    public func getMaxHeartRate(_ completion: @escaping (Result<Int?, Error>) -> Void) {
        let maxHeartRate: ([Run]) -> Int? = { runs in
            return runs
                .compactMap { $0.maxHeartRate }
                .max()
        }
        
        if let runs = runs {
            completion(.success(maxHeartRate(runs)))
        } else {
            loadRuns { result in
                switch result {
                case .success(let runs):
                    completion(.success(maxHeartRate(runs)))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}
