//
//  ProgressViewController.swift
//  Ranalyse
//
//  Created by Mykhailo Moiseienko on 5/29/19.
//  Copyright © 2019 Mykhailo Moiseienko. All rights reserved.
//

import UIKit

class ProgressViewController: UIViewController {
    enum Constant {
        static let progressFormat = NSLocalizedString("%d of %d runs analyzed", comment: "")
    }
    
    // MARK: - Outlets
    
    @IBOutlet var progressView: UIProgressView!
    @IBOutlet weak var progressLabel: UILabel!
    
    // MARK: - Properties
    
    var runs: [Run]?
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        loadData()
    }
    
    private func setupView() {
        title = NSLocalizedString("Progress", comment: "")
    }
    
    @objc
    private func loadData() {
        progressLabel.text = NSLocalizedString("Loading Data", comment: "")
        
        DataStore.shared.getRuns { [weak self] result in
            switch result {
            case .success(let runs):
                self?.runs = runs
                self?.showProgress()
            case .failure(let error):
                self?.showError(error)
            }
        }
    }
    
    func showProgress() {
        guard let runs = runs else { return }
        
        var progress = [VDOT]()
        
        DispatchQueue.global(qos: .default).async { [weak self] in
            let group = DispatchGroup()
            var failedVDOTCount = 0
            
            for run in runs {
                group.enter()
                run.vdot { vdot in
                    if let vdot = vdot {
                        progress.append(vdot)
                    } else {
                        failedVDOTCount += 1
                    }
                    
                    DispatchQueue.main.async {
                        self?.updateProgress(with: progress.count + failedVDOTCount, totalNumber: runs.count)
                    }
                    
                    group.leave()
                }
            }
            
            group.notify(queue: .main) {
                self?.showProgressChart(for: progress)
            }
        }
    }

    func updateProgress(with analyzedNumber: Int, totalNumber: Int) {
        progressLabel.text = String(format: Constant.progressFormat, analyzedNumber, totalNumber)
        progressView.progress = Float(analyzedNumber) / Float(totalNumber)
    }
    
    func showProgressChart(for data: [VDOT]) {
        guard let viewController = storyboard?.instantiateViewController(withIdentifier: "ProgressChartViewController") as? ProgressChartViewController else { return }
        
        viewController.progressData = data
        
        navigationController?.setViewControllers([viewController], animated: true)
    }
    
}
