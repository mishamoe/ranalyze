//
//  ProgressViewController.swift
//  Ranalyse
//
//  Created by Mykhailo Moiseienko on 5/29/19.
//  Copyright © 2019 Mykhailo Moiseienko. All rights reserved.
//

import UIKit

class ProgressViewController: UIViewController {

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
        
        var progress = [(Run, VDOT)]()
        
        DispatchQueue.global(qos: .default).async {
            let group = DispatchGroup()
            
            for run in runs {
                group.enter()
                run.vdot { vdot in
                    if let vdot = vdot {
                        progress.append((run, vdot))
                    }
                    
                    group.leave()
                }
            }
            
            group.notify(queue: .main) {
                for (run, vdot) in progress {
                    if let date = run.date {
                        print("\(Formatter.date(date)): VDOT = \(vdot.formattedValue)")
                    }
                }
            }
        }
    }

}
