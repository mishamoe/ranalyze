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
    case averagePace
    case averageHeartRate
    case maxHeartRate

    // Second section
    case farthestRun    // Самая дальняя
    case longestRun     // Самая длительная
    
    // Third Section
    case fastestOneKilometer
    case fastestFiveKilometers
    case fastestTenKilometer
    case fastestHalfMarathon
    case fastestMarathon
}

class ResultsViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet private weak var tableView: UITableView!
    
    lazy var refreshControl: UIRefreshControl! = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(loadData), for: .valueChanged)
        return refreshControl
    }()
    
    // MARK: - Properties
    
    let sections: [[ResultsRow]] = [
        [.averagePace, .averageHeartRate, .maxHeartRate],
        [.farthestRun, .longestRun],
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
        title = NSLocalizedString("Results", comment: "")
        tableView.refreshControl = refreshControl
    }

    @objc
    private func loadData() {
        let group = DispatchGroup()
        
        group.enter()
        DataStore.shared.getMaxHeartRate { [weak self] result in
            if case .success(let maxHeartRate) = result {
                self?.results.maxHeartRate = maxHeartRate
            }
            group.leave()
        }
        
        group.notify(queue: .main) { [weak self] in
            self?.tableView.reloadData()
            self?.refreshControl.endRefreshing()
        }
    }
    
}

extension ResultsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].count
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
        case .averagePace: return NSLocalizedString("Average Pace", comment: "")
        case .averageHeartRate: return NSLocalizedString("Average Heart Rate", comment: "")
        case .maxHeartRate: return NSLocalizedString("Max Heart Rate", comment: "")
            
        case .farthestRun: return NSLocalizedString("Farthest Run", comment: "")
        case .longestRun: return NSLocalizedString("Longest Run", comment: "")
            
        case .fastestOneKilometer: return NSLocalizedString("Fastest 1KM", comment: "")
        case .fastestFiveKilometers: return NSLocalizedString("Fastest 5KM", comment: "")
        case .fastestTenKilometer: return NSLocalizedString("Fastest 10KM", comment: "")
        case .fastestHalfMarathon: return NSLocalizedString("Fastest Half Marathon", comment: "")
        case .fastestMarathon: return NSLocalizedString("Fastest Marathon", comment: "")
        }
    }
    
    func formattedValue(from results: Results) -> String {
        switch self {
        case .averagePace: return results.formattedAveragePace
        case .averageHeartRate: return results.formattedAverageHeartRate
        case .maxHeartRate: return results.formattedMaxHeartRate
            
        case .farthestRun: return results.formattedFarthestRun
        case .longestRun: return results.formattedLongestRun
            
        case .fastestOneKilometer: return results.formattedFastestOneKilometer
        case .fastestFiveKilometers: return results.formattedFastestFiveKilometers
        case .fastestTenKilometer: return results.formattedFastestTenKilometer
        case .fastestHalfMarathon: return results.formattedFastestHalfMarathon
        case .fastestMarathon: return results.formattedFastestMarathon
        }
    }
}
