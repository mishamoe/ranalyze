//
//  AnalysisProgressViewController.swift
//  Ranalyse
//
//  Created by Mykhailo Moiseienko on 6/11/19.
//  Copyright © 2019 Mykhailo Moiseienko. All rights reserved.
//

import UIKit

protocol AnalysisProgressDelegate: class {
    var totalNumberOfRuns: Int { get }
    var initialProgressText: String? { get }
}

extension AnalysisProgressDelegate {
    var initialProgressText: String? {
        return NSLocalizedString("Loading Data", comment: "")
    }
}

class AnalysisProgressViewController: UIViewController {
    enum Constant {
        static let progressFormat = NSLocalizedString("%d of %d runs analyzed", comment: "")
    }
    
    // MARK: - Outlets
    
    @IBOutlet var progressView: UIProgressView!
    @IBOutlet weak var progressLabel: UILabel!
    
    // MARK: - Properties
    
    weak var delegate: AnalysisProgressDelegate?
    
    private var analyzedNumber: Int = 0
    private var totalNumber: Int {
        return delegate?.totalNumberOfRuns ?? 0
    }
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private func setupView() {
        title = NSLocalizedString("Analysis in progress", comment: "")
        
        progressView.progress = 0.0
        if let initialProgressText = delegate?.initialProgressText {
            progressLabel.text = initialProgressText
        }
    }
    
    private func updateProgress() {
        progressLabel.text = String(format: Constant.progressFormat, analyzedNumber, totalNumber)
        progressView.progress = Float(analyzedNumber) / Float(totalNumber)
    }
    
    // MARK: - Public methods
    
    func incrementProgress() {
        analyzedNumber += 1
        updateProgress()
    }
    
    func updateProgress(with analyzedNumber: Int) {
        self.analyzedNumber = analyzedNumber
        updateProgress()
    }
}
