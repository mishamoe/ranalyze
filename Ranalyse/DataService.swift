//
//  DataService.swift
//  Ranalyse
//
//  Created by Mykhailo Moiseienko on 5/21/19.
//  Copyright © 2019 Mykhailo Moiseienko. All rights reserved.
//

import Foundation

struct DataService {
    func loadRuns(completion: @escaping (Result<[Run], RanalyzeError>) -> Void) {
        let gpxFileNames = [
            "Nova_Poshta_Kyiv_Half_Marathon",
            "May_9",
            "May_12",
            "May_18",
            "May_20",
            "May_24",
            "May_29",
            "May_30",
            "Interpipe_Dnipro_Half_Marathon"
        ]
        
        DispatchQueue.global(qos: .userInitiated).async {
            let runs = gpxFileNames
                .compactMap { Run.run(fromGPXFile: $0) }
                .sorted { ($0.date ?? Date()) > ($1.date ?? Date()) }
            
            DispatchQueue.main.async {
                completion(.success(runs))
            }
        }
    }
    
    func findFastestSplit(runs: [Run]) -> Result<Split, RanalyzeError> {
        let allSplits = runs.flatMap { $0.splits }
        
        guard var fastestSplit = allSplits.first else {
            return .failure(.errorWhenFindingFastestSplit)
        }
        
        for split in allSplits {
            if split.pace > fastestSplit.pace {
                fastestSplit = split
            }
        }
        
        return .success(fastestSplit)
    }
    
    func findMaxHeartRate(runs: [Run]) -> Result<BPM, RanalyzeError> {
        let maxHeartRate = runs
            .compactMap { $0.maxHeartRate }
            .max()
        
        if let maxHeartRate = maxHeartRate {
            return .success(maxHeartRate)
        } else {
            return .failure(.errorWhenFindingMaxHeartRate)
        }
    }
    
    func findBestVDOTForLastTwoWeeks(runs: [Run], completion: @escaping (Result<VDOT, RanalyzeError>) -> Void) {
        findBestVDOT(runs: runs.forLastTwoWeeks(), completion: completion)
    }
    
    func findBestVDOT(runs: [Run], completion: @escaping (Result<VDOT, RanalyzeError>) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            var vdots = [VDOT]()
            let group = DispatchGroup()
            
            let _ = DispatchQueue.global(qos: .userInitiated)
            DispatchQueue.concurrentPerform(iterations: runs.count) { index in
                let run = runs[index]
                group.enter()
                run.vdot { vdot in
                    if let vdot = vdot {
                        vdots.append(vdot)
                    } else {
                        print("Error: VDOT for run \(index + 1)/\(runs.count) is nil")
                    }
                    
                    group.leave()
                }
            }
            
            group.notify(queue: .main) {
                if let bestVDOT = vdots.max() {
                    completion(.success(bestVDOT))
                } else {
                    completion(.failure(RanalyzeError.errorWhenFindingBestVDOT))
                }
            }
        }
    }
}
