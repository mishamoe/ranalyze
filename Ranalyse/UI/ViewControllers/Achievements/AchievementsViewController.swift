//
//  ResultsViewController.swift
//  Ranalyse
//
//  Created by Mykhailo Moiseienko on 5/25/19.
//  Copyright © 2019 Mykhailo Moiseienko. All rights reserved.
//

import UIKit

enum ResultsRow {
    // First section
    case averageHeartRate
    case maxHeartRate

    // Second section
    case farthestRun    // Самая дальняя
    case longestRun     // Самая длительная
    
    // Third Section
    case averagePace
    
    // Fourth Section
    case fastestOneKilometer
    case fastestFiveKilometers
    case fastestTenKilometer
    case fastestHalfMarathon
    case fastestMarathon
}

class AchievementsViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet private weak var tableView: UITableView!
    
    lazy var refreshControl: UIRefreshControl! = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(loadData), for: .valueChanged)
        return refreshControl
    }()
    
    // MARK: - Properties
    
    let sections: [[ResultsRow]] = [
        [.averageHeartRate, .maxHeartRate],
        [.farthestRun, .longestRun],
        [.averagePace],
        [.fastestOneKilometer, .fastestFiveKilometers, .fastestTenKilometer, .fastestHalfMarathon, .fastestMarathon]
    ]
    
    var results = Results()
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        loadData()
    }
    
    private func setupView() {
        title = NSLocalizedString("Achievements", comment: "")
        tableView.refreshControl = refreshControl
    }

    @objc
    private func loadData() {
        refreshControl.beginRefreshing()
        
        DataStore.shared.getRuns { [weak self] result in
            switch result {
            case .success(let runs):
                let analyzer = ResultsAnalyzer(runs: runs)
                analyzer.getResults() { [weak self] results in
                    self?.results = results
                    self?.tableView.reloadData()
                    self?.refreshControl.endRefreshing()
                }
            case .failure(let error):
                self?.showError(error)
            }
        }
    }
    
}

extension AchievementsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return NSLocalizedString("Heart Rate", comment: "")
        case 1:
            return NSLocalizedString("Best Results", comment: "")
        case 2:
            return NSLocalizedString("Average Pace", comment: "")
        case 3:
            return NSLocalizedString("Achievements", comment: "")
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = sections[indexPath.section][indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultsTableViewCell", for: indexPath)
        
        cell.textLabel?.text = row.title
        cell.detailTextLabel?.text = row.formattedValue(from: results)
        
        return cell
    }
}

extension ResultsRow {
    var title: String {
        switch self {
        case .averageHeartRate: return NSLocalizedString("Average Heart Rate", comment: "")
        case .maxHeartRate: return NSLocalizedString("Max Heart Rate", comment: "")
            
        case .farthestRun: return NSLocalizedString("Farthest Run", comment: "")
        case .longestRun: return NSLocalizedString("Longest Run", comment: "")
            
        case .averagePace: return NSLocalizedString("Average Pace", comment: "")
            
        case .fastestOneKilometer: return NSLocalizedString("Fastest 1 km", comment: "")
        case .fastestFiveKilometers: return NSLocalizedString("Fastest 5 km", comment: "")
        case .fastestTenKilometer: return NSLocalizedString("Fastest 10 km", comment: "")
        case .fastestHalfMarathon: return NSLocalizedString("Fastest Half Marathon", comment: "")
        case .fastestMarathon: return NSLocalizedString("Fastest Marathon", comment: "")
        }
    }
    
    func formattedValue(from results: Results) -> String {
        switch self {
        case .averageHeartRate: return results.formattedAverageHeartRate
        case .maxHeartRate: return results.formattedMaxHeartRate
            
        case .farthestRun: return results.formattedFarthestRun
        case .longestRun: return results.formattedLongestRun
            
        case .averagePace: return results.formattedAveragePace
            
        case .fastestOneKilometer: return results.formattedFastestOneKilometer
        case .fastestFiveKilometers: return results.formattedFastestFiveKilometers
        case .fastestTenKilometer: return results.formattedFastestTenKilometer
        case .fastestHalfMarathon: return results.formattedFastestHalfMarathon
        case .fastestMarathon: return results.formattedFastestMarathon
        }
    }
}
