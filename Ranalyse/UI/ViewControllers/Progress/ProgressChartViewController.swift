//
//  ProgressChartViewController.swift
//  Ranalyse
//
//  Created by Mykhailo Moiseienko on 5/30/19.
//  Copyright © 2019 Mykhailo Moiseienko. All rights reserved.
//

import UIKit
import ResearchKit

class ProgressChartViewController: UIViewController {

    @IBOutlet weak var chartView: ORKDiscreteGraphChartView!
    
    var progressData: [VDOT]!
    var grouoppedProgress: [WeekProgress]!
    var plotPoints = [ORKValueRange]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        assert(progressData != nil)
        
        grouoppedProgress = progressGrouppedByWeek()
        
        for weekProgress in grouoppedProgress {
            let valueRange = ORKValueRange(minimumValue: weekProgress.minVDOT, maximumValue: weekProgress.maxVDOT)
            plotPoints.append(valueRange)
        }
        
//        for (run, vdot) in progressData {
//            if let date = run.date {
//                print("\(Formatter.date(date)): VDOT = \(vdot.formattedValue)")
//            }
//        }
        
        setupChartView()
    }

    func setupChartView() {
        chartView.dataSource = self
        
        chartView.showsHorizontalReferenceLines = true
        chartView.showsVerticalReferenceLines = true
        
        chartView.axisColor = UIColor.white
        chartView.verticalAxisTitleColor = UIColor.orange
        chartView.scrubberLineColor = UIColor.red
    }
    
    func progressGrouppedByWeek() -> [WeekProgress] {
//        var grouppedProgress = [Week: [VDOT]]()
//        for vdot in progressData {
//            guard let date = vdot.date, let week = date.week else { continue }
//
//            if grouppedProgress[week] == nil {
//                grouppedProgress[week] = [VDOT]()
//            }
//
//            grouppedProgress[week]?.append(vdot)
//        }
        
        var progress = [WeekProgress]()
        for vdot in progressData {
            guard let date = vdot.date, let week = date.week else { continue }
            if let weekProgress = progress.first(where: { $0.week == week }) {
                weekProgress.addVDOT(vdot)
            } else {
                progress.append(WeekProgress(week: week, vdots: [vdot]))
            }
        }
        progress.sort { lhs, rhs -> Bool in
            return lhs.week.startDate < rhs.week.startDate
        }
        
        for weekProgress in progress {
            print("\(Formatter.date(weekProgress.week.startDate))-\(Formatter.date(weekProgress.week.endDate)): \(weekProgress.vdots.count)")
        }
        
        
        return progress
    }
}

extension ProgressChartViewController: ORKValueRangeGraphChartViewDataSource {
    func graphChartView(_ graphChartView: ORKGraphChartView, dataPointForPointIndex pointIndex: Int, plotIndex: Int) -> ORKValueRange {
        return plotPoints[pointIndex]
    }
    
    func graphChartView(_ graphChartView: ORKGraphChartView, numberOfDataPointsForPlotIndex plotIndex: Int) -> Int {
        return plotPoints.count
    }
    
    func numberOfPlots(in graphChartView: ORKGraphChartView) -> Int {
        return 1
    }
    
    func minimumValue(for graphChartView: ORKGraphChartView) -> Double {
        return 30
    }
    
    func maximumValue(for graphChartView: ORKGraphChartView) -> Double {
        if let max = progressData.max()?.value {
            return max + 10
        }
        return 85
    }
    
    func graphChartView(_ graphChartView: ORKGraphChartView, titleForXAxisAtPointIndex pointIndex: Int) -> String? {
        return Formatter.week(grouoppedProgress[pointIndex].week)
    }
}
