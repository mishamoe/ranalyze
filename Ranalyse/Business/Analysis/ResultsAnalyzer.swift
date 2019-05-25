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
        var results = Results()
        
        results.averagePace = self.getAveragePace()
        results.averageHeartRate = self.getAverageHeartRate()
        results.maxHeartRate = self.getMaxHeartRate()
        results.longestRun = self.getLongestRun()?.duration
        results.farthestRun = self.getFarthestRun()?.distance
        
        let queue = DispatchQueue.global(qos: .userInitiated)
        let group = DispatchGroup()
        let startTime = Date()
        
        queue.async(group: group, execute: DispatchWorkItem(block: {
            results.fastestOneKilometer = self.getFastestOneKilometerTime()
        }))
        queue.async(group: group, execute: DispatchWorkItem(block: {
            results.fastestFiveKilometers = self.getFastestFiveKilometerTime()
        }))
        queue.async(group: group, execute: DispatchWorkItem(block: {
            results.fastestTenKilometers = self.getFastestTenKilometerTime()
        }))
        queue.async(group: group, execute: DispatchWorkItem(block: {
            results.fastestHalfMarathon = self.getFastestHalfMarathonTime()
        }))
        queue.async(group: group, execute: DispatchWorkItem(block: {
            results.fastestMarathon = self.getFastestMarathonTime()
        }))
        
        group.notify(queue: .main) {
            print(Formatter.duration(Date().timeIntervalSince(startTime)))
            completion(results)
        }
        
        /*
        DispatchQueue.global(qos: .userInitiated).async {
            var results = Results()
            
            results.averagePace = self.getAveragePace()
            results.averageHeartRate = self.getAverageHeartRate()
            results.maxHeartRate = self.getMaxHeartRate()
            results.longestRun = self.getLongestRun()?.duration
            results.farthestRun = self.getFarthestRun()?.distance
            
            let startTime = Date()
            
            let queue = OperationQueue()
            queue.qualityOfService = .userInitiated
            queue.maxConcurrentOperationCount = OperationQueue.defaultMaxConcurrentOperationCount
            queue.addOperation {
                results.fastestOneKilometer = self.getFastestOneKilometerTime()
            }
            queue.addOperation {
                results.fastestFiveKilometers = self.getFastestFiveKilometerTime()
            }
            queue.addOperation {
                results.fastestTenKilometers = self.getFastestTenKilometerTime()
            }
            queue.addOperation {
                results.fastestHalfMarathon = self.getFastestHalfMarathonTime()
            }
            queue.addOperation {
                results.fastestMarathon = self.getFastestMarathonTime()
            }
            queue.waitUntilAllOperationsAreFinished()
            
            DispatchQueue.main.async {
                print(Formatter.duration(Date().timeIntervalSince(startTime)))
                completion(results)
            }
        }
        */
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
    
    func getFastestOneKilometerTime() -> Duration? {
        return runs
            .compactMap { $0.fastestOneKilometer }
            .min()
    }
    
    func getFastestFiveKilometerTime() -> Duration? {
        return runs
            .compactMap { $0.fastestFiveKilometer }
            .min()
    }
    
    func getFastestTenKilometerTime() -> Duration? {
        return runs
            .compactMap { $0.fastestTenKilometer }
            .min()
    }
    
    func getFastestHalfMarathonTime() -> Duration? {
        return runs
            .compactMap { $0.fastestHalfMarathon }
            .min()
    }
    
    func getFastestMarathonTime() -> Duration? {
        return runs
            .compactMap { $0.fastestMarathon }
            .min()
    }
}
