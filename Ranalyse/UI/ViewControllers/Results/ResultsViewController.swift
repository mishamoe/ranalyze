//
//  ResultsViewController.swift
//  Ranalyse
//
//  Created by Mykhailo Moiseienko on 6/3/19.
//  Copyright © 2019 Mykhailo Moiseienko. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    
    private lazy var analysisProgressViewController: AnalysisProgressViewController = {
        let vc = AnalysisProgressViewController(nibName: "AnalysisProgressViewController", bundle: nil)
        vc.delegate = self
        return vc
    }()
    
    lazy var refreshControl: UIRefreshControl! = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(loadData), for: .valueChanged)
        return refreshControl
    }()
    
    private var isFirstTimeAppearance = true
    
    private var runs: [Run]?
    private var bestVDOT: VDOT?
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        loadData()
    }
    
    private func setupView() {
        title = NSLocalizedString("Results", comment: "")
        tableView.refreshControl = refreshControl
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        
//        if isFirstTimeAppearance {
//            loadData()
//            isFirstTimeAppearance = false
//        }
//    }

    @objc
    func loadData() {
//        present(analysisProgressViewController, animated: true)
        refreshControl.beginRefreshing()
        
        DataStore.shared.getRuns { [weak self] result in
            switch result {
            case .success(var runs):
                runs = runs.forLastMonth()
                self?.runs = runs
//                self?.analysisProgressViewController.updateProgress(with: 0)
                
                self?.getVDOTs(for: runs) { [weak self] result in
                    switch result {
                    case .success(let vdots):
                        self?.bestVDOT = vdots.max()
                        self?.tableView.reloadData()
                        self?.refreshControl.endRefreshing()
//                        self?.analysisProgressViewController.dismiss(animated: true)
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
                        print("Error: VDOT for run \(run.name ?? "") \(index + 1)/\(runs.count) is nil")
                    }
                    
//                    self?.analysisProgressViewController.incrementProgress()
                    group.leave()
                }
            }
            
            group.notify(queue: .main) {
                completion(.success(vdots))
            }
        }
    }

}

extension ResultsViewController: AnalysisProgressDelegate {
    var totalNumberOfRuns: Int {
        return runs?.count ?? 0
    }
}

extension ResultsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return KnownDistance.all.count
        default:
            fatalError("Undefined section (\(section))")
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultTableViewCell", for: indexPath)
        
        switch indexPath.section {
        case 0:
            cell.textLabel?.text = NSLocalizedString("Best VDOT for the last month", comment: "")
            
            if let bestVDOT = bestVDOT {
                cell.detailTextLabel?.text = Formatter.vdot(bestVDOT)
            } else {
                cell.detailTextLabel?.text = NSLocalizedString("N/A", comment: "")
            }
        case 1:
            let distance = KnownDistance.all[indexPath.row]
            cell.textLabel?.text = distance.formattedValue
            
            if let bestVDOT = bestVDOT, let result = bestVDOT.results[distance] {
                cell.detailTextLabel?.text = Formatter.duration(result)
            } else {
                cell.detailTextLabel?.text = NSLocalizedString("N/A", comment: "")
            }
        default:
            fatalError("Undefined section (\(indexPath.section))")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        switch section {
        case 0:
            return NSLocalizedString("All runs for the last runs were analyzed to receive best VDOT value.", comment: "")
        case 1:
            return NSLocalizedString("These approximate results suggest that the runner will do his best during the race.", comment: "")
        default:
            fatalError("Undefined section (\(section))")
        }
    }
}
