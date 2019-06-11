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

    @IBOutlet private weak var chartView: ORKDiscreteGraphChartView!
    
    private var runs: [Run]?
    private var vdots: [VDOT]?
    
    private var isFirstTimeAppearance = true
    
    private lazy var analysisProgressViewController: AnalysisProgressViewController = {
        let vc = AnalysisProgressViewController(nibName: "AnalysisProgressViewController", bundle: nil)
        vc.delegate = self
        return vc
    }()
    
    private var grouppedProgress: [WeekProgress]!
    private var plotPoints = [ORKValueRange]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    private func setupView() {
        title = NSLocalizedString("Progress", comment: "")
        setupChartView()
    }
    
    private func setupChartView() {
        chartView.dataSource = self
        
        chartView.showsHorizontalReferenceLines = true
        chartView.showsVerticalReferenceLines = true
        
        chartView.axisColor = UIColor.white
        chartView.verticalAxisTitleColor = UIColor.orange
        chartView.scrubberLineColor = UIColor.red
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if isFirstTimeAppearance {
            present(analysisProgressViewController, animated: true)
            loadData()
            isFirstTimeAppearance = false
        }
    }
    
    @objc
    private func loadData() {
        DataStore.shared.getRuns { [weak self] result in
            switch result {
            case .success(let runs):
                self?.runs = runs
                self?.analysisProgressViewController.updateProgress(with: 0)
                
                self?.getVDOTs(for: runs) { [weak self] result in
                    switch result {
                    case .success(let vdots):
                        self?.vdots = vdots
                        self?.populatePlotPoints()
                        self?.chartView.reloadData()
                        self?.analysisProgressViewController.dismiss(animated: true)
                    case .failure(let error):
                        self?.showError(error)
                    }
                }
            case .failure(let error):
                self?.showError(error)
            }
        }
    }
    
    private func getVDOTs(for runs: [Run], completion: @escaping (Result<[VDOT], RanalyzeError>) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            var vdots = [VDOT]()
            let group = DispatchGroup()
            
            let _ = DispatchQueue.global(qos: .userInitiated)
            DispatchQueue.concurrentPerform(iterations: runs.count) { [weak self] index in
                let run = runs[index]
                group.enter()
                run.vdot { vdot in
                    if let vdot = vdot {
                        vdots.append(vdot)
                    } else {
                        print("Error: VDOT for run \(index + 1)/\(runs.count) is nil")
                    }
                    
                    self?.analysisProgressViewController.incrementProgress()
                    group.leave()
                }
            }
            
            group.notify(queue: .main) {
                completion(.success(vdots))
            }
        }
    }
    
    private func populatePlotPoints() {
        grouppedProgress = progressGrouppedByWeek()
        
        for weekProgress in grouppedProgress {
            let valueRange = ORKValueRange(minimumValue: weekProgress.minVDOT, maximumValue: weekProgress.maxVDOT)
            plotPoints.append(valueRange)
        }
    }
    
    private func progressGrouppedByWeek() -> [WeekProgress] {
        guard let vdots = vdots else { return [] }
        
        var progress = [WeekProgress]()
        for vdot in vdots {
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

extension ProgressChartViewController: AnalysisProgressDelegate {
    var totalNumberOfRuns: Int {
        return runs?.count ?? 0
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
        if let max = vdots?.max()?.value {
            return max + 10
        }
        return 85
    }
    
    func graphChartView(_ graphChartView: ORKGraphChartView, titleForXAxisAtPointIndex pointIndex: Int) -> String? {
        return Formatter.week(grouppedProgress[pointIndex].week)
    }
}
