//
//  VDOTDatabase.swift
//  Ranalyse
//
//  Created by Mykhailo Moiseienko on 5/29/19.
//  Copyright © 2019 Mykhailo Moiseienko. All rights reserved.
//

import Foundation

/// https://en.wikipedia.org/wiki/Jack_Daniels_(coach)#VDOT
struct VDOTDatabase {
    static let knowsVDOTs: [VDOT] = {
        return parseContent(readCSVFile("VDOT"))
    }()
    
    static func accurateVDOT(distance: KnownDistance, duration: Duration) -> VDOT? {
        guard !knowsVDOTs.isEmpty else { return nil }
        
        for i in 1..<knowsVDOTs.count {
            let previousVDOT = knowsVDOTs[i - 1]
            let currentVDOT = knowsVDOTs[i]
            
            guard let previousResult = previousVDOT.results[distance],
                let currentResult = currentVDOT.results[distance] else { continue }
            
            // VDOT duration should be between previous and current
            if duration < previousResult && duration > currentResult {
                let realVDOTValue = VDOTDatabase.linearInterpolation(x0: previousResult,
                                                                     y0: previousVDOT.value,
                                                                     x1: currentResult,
                                                                     y1: currentVDOT.value,
                                                                     x: duration)
                
                var realResults = [KnownDistance : Duration]()
                for distance in KnownDistance.all {
                    if let previousResult = previousVDOT.results[distance],
                        let currentResult = currentVDOT.results[distance] {
                        realResults[distance] = VDOTDatabase.linearInterpolation(x0: previousVDOT.value,
                                                                                 y0: previousResult,
                                                                                 x1: currentVDOT.value,
                                                                                 y1: currentResult,
                                                                                 x: realVDOTValue)
                    }
                }
                
                return VDOT(value: realVDOTValue, results: realResults)
            }
        }
        
        return nil
    }
}

extension VDOTDatabase {
    /// https://en.wikipedia.org/wiki/Linear_interpolation
    static func linearInterpolation(x0: Double, y0: Double, x1: Double, y1: Double, x: Double) -> Double {
        let y = ((x - x0) * (y1 - y0) / (x1 - x0)) + y0
        return y
    }
    
    static func readCSVFile(_ name: String) -> [[String]] {
        guard let path = Bundle.main.path(forResource: name, ofType: "csv") else {
            return []
        }
        
        guard let data = try? String(contentsOfFile: path, encoding: .utf8) else {
            return []
        }
        
        let rowSeparator = "\r\n"
        let columnSeparator = ","
        
        return data
            .components(separatedBy: rowSeparator)
            .map { $0.components(separatedBy: columnSeparator) }
    }
    
    static func parseContent(_ content: [[String]]) -> [VDOT] {
        let indexVDOT = 0
        let index1500 = 1
        let index3000 = 3
        let index5000 = 5
        let index10000 = 6
        let index15000 = 7
        let indexHalfMarathon = 8
        let indexMarathon = 9
        
        var vdotArray = [VDOT]()
        
        // Skip first row (header)
        for row in content[1..<content.endIndex] {
            guard row.count == 10 else {
                continue
            }
            
            guard let vdotValue = Double(row[indexVDOT]),
                let result1500 = Duration(string: row[index1500]),
                let result3000 = Duration(string: row[index3000]),
                let result5000 = Duration(string: row[index5000]),
                let result10000 = Duration(string: row[index10000]),
                let result15000 = Duration(string: row[index15000]),
                let resultHalfMarathon = Duration(string: row[indexHalfMarathon]),
                let resultMarathon = Duration(string: row[indexMarathon]) else {
                    continue
            }
            
            let vdot = VDOT(value: vdotValue, results: [.distance1500: result1500,
                                                        .distance3000: result3000,
                                                        .distance5000: result5000,
                                                        .distance10000: result10000,
                                                        .distance15000: result15000,
                                                        .distanceHalfMarathon: resultHalfMarathon,
                                                        .distanceMarathon: resultMarathon])
            vdotArray.append(vdot)
        }
        
        return vdotArray
    }
}
