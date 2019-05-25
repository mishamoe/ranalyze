//
//  ResultsCalculator.swift
//  Ranalyse
//
//  Created by Mykhailo Moiseienko on 5/25/19.
//  Copyright © 2019 Mykhailo Moiseienko. All rights reserved.
//

import Foundation

struct ResultsAnalyzer {
    
    let runs: [Run]
    
    func getResults(_ completion: @escaping (Results) -> Void) {
        DispatchQueue.global(qos: .utility).async {
            var results = Results()
            
            results.averagePace = self.getAveragePace()
            results.averageHeartRate = self.getAverageHeartRate()
            results.maxHeartRate = self.getMaxHeartRate()
            results.longestRun = self.getLongestRun()?.duration
            results.farthestRun = self.getFarthestRun()?.distance
            
            DispatchQueue.main.async {
                completion(results)
            }
        }
    }
    
    func getAveragePace() -> Pace? {
        let pacesArray = runs.map { $0.pace }
        
        guard !pacesArray.isEmpty else { return nil }
        
        let sum = pacesArray.reduce(0.0, +)
        return sum / Double(pacesArray.count)
    }
    
    func getAverageHeartRate() -> BPM? {
        let heartRateArray = runs.compactMap { $0.averageHeartRate }
        
        guard !heartRateArray.isEmpty else { return nil }
        
        let sum = heartRateArray.reduce(0, +)
        return sum / heartRateArray.count
    }
    
    func getMaxHeartRate() -> BPM? {
        return runs
            .compactMap { $0.maxHeartRate }
            .max()
    }
    
    func getLongestRun() -> Run? {
        guard var longestRun = runs.first else { return nil }
        
        for run in runs[1..<runs.endIndex] {
            if run.duration > longestRun.duration {
                longestRun = run
            }
        }
        
        return longestRun
    }
    
    func getFarthestRun() -> Run? {
        guard var farthestRun = runs.first else { return nil }
        
        for run in runs[1..<runs.endIndex] {
            if run.distance > farthestRun.distance {
                farthestRun = run
            }
        }
        
        return farthestRun
    }
}
