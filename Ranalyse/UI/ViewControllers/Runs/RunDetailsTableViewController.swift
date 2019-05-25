//
//  RunDetailsTableViewController.swift
//  Ranalyse
//
//  Created by Mykhailo Moiseienko on 5/12/19.
//  Copyright © 2019 Mykhailo Moiseienko. All rights reserved.
//

import UIKit

enum RunDetails {
    case distance
    case duration
    case pace
    case minHeartRate
    case maxHeartRate
    case averageHeartRate
    case cumulativeElevationGain
    
    var title: String {
        switch self {
        case .distance: return NSLocalizedString("Distance", comment: "")
        case .duration: return NSLocalizedString("Duration", comment: "")
        case .pace: return NSLocalizedString("Pace", comment: "")
        case .minHeartRate: return NSLocalizedString("Minimal Heart Rate", comment: "")
        case .maxHeartRate: return NSLocalizedString("Maximal Heart Rate", comment: "")
        case .averageHeartRate: return NSLocalizedString("Average Heart Rate", comment: "")
        case .cumulativeElevationGain: return NSLocalizedString("Cumulative Elevation Gain", comment: "")
        }
    }
}

class RunDetailsTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    private let details: [RunDetails] = [.distance,
                                         .duration,
                                         .pace,
                                         .minHeartRate,
                                         .maxHeartRate,
                                         .averageHeartRate,
                                         .cumulativeElevationGain]
    
    var run: Run!
    
    // MARK: - View Controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        assert(run != nil)
        
        title = run.name
        
        _ = run.splits
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return details.count
        case 1:
            return 1
        case 2:
            return 1
        default:
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RunCell", for: indexPath)
        
        switch indexPath.section {
        case 0:
            let detail = details[indexPath.row]
            
            cell.textLabel?.text = detail.title
            cell.detailTextLabel?.text = NSLocalizedString("N/A", comment: "")
            cell.accessoryType = .none
            cell.selectionStyle = .none
            
            switch detail {
            case .distance:
                cell.detailTextLabel?.text = Formatter.distance(valueInMeters: run.distance)
            case .duration:
                cell.detailTextLabel?.text = Formatter.duration(run.duration)
            case.pace:
                cell.detailTextLabel?.text = Formatter.pace(run.pace)
            case .minHeartRate:
                if let minHeartRate = run.minHeartRate {
                    cell.detailTextLabel?.text = Formatter.heartRate(minHeartRate)
                }
            case .maxHeartRate:
                if let maxHeartRate = run.maxHeartRate {
                    cell.detailTextLabel?.text = Formatter.heartRate(maxHeartRate)
                }
            case .averageHeartRate:
                if let averageHeartRate = run.averageHeartRate {
                    cell.detailTextLabel?.text = Formatter.heartRate(averageHeartRate)
                }
            case .cumulativeElevationGain:
                cell.detailTextLabel?.text = Formatter.cumulativeElevationGain(run.cumulativeElevationGain)
            }
        case 1:
            cell.textLabel?.text = NSLocalizedString("Splits", comment: "")
            cell.detailTextLabel?.text = nil
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .default
        case 2:
            cell.textLabel?.text = NSLocalizedString("Heart Rate Zones", comment: "")
            cell.detailTextLabel?.text = nil
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = run.heartRateAnalysis == nil ? .none : .default
        default:
            break
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch (indexPath.section, indexPath.row)  {
        case (1, 0): presentSplitsViewController()
        case (2, 0): presentHeartRateZonesViewController()
        default: break
        }
    }
    
    // MARK: - Actions
    
    func presentSplitsViewController() {
        guard let viewController = storyboard?.instantiateViewController(withIdentifier: "SplitsViewController") as? SplitsViewController else {
            return
        }
        
        viewController.splits = run.splits
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func presentHeartRateZonesViewController() {
        guard let viewController = storyboard?.instantiateViewController(withIdentifier: "HeartRateZonesViewController") as? HeartRateZonesViewController else {
            return
        }
        
        viewController.heartRateAnalysis = run.heartRateAnalysis
        navigationController?.pushViewController(viewController, animated: true)
    }
    
}
