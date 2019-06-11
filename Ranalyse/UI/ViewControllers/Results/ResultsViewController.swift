//
//  ResultsViewController.swift
//  Ranalyse
//
//  Created by Mykhailo Moiseienko on 6/3/19.
//  Copyright © 2019 Mykhailo Moiseienko. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController {

    var bestVDOT: VDOT?
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        loadData()
    }
    
    private func setupView() {
        title = NSLocalizedString("Results", comment: "")
    }

    func loadData() {
        DataStore.shared.getBestVDOT { [weak self] result in
            switch result {
            case .success(let vdot):
                self?.bestVDOT = vdot
                print("Best VDOT for last two weeks: \(vdot)")
            case .failure(let error):
                self?.showError(error)
            }
        }
    }

}
