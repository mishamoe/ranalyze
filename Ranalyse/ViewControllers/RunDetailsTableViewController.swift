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
    case minHeartRate
    case maxHeartRate
    case averageHeartRate
    case cumulativeElevationGain
    
    var title: String {
        switch self {
        case .distance: return NSLocalizedString("Distance", comment: "")
        case .duration: return NSLocalizedString("Duration", comment: "")
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
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return details.count
        case 1:
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
            
            switch detail {
            case .distance:
                cell.detailTextLabel?.text = String(format: "%.2f km", run.distance / 1000)
            case .duration:
                cell.detailTextLabel?.text = run.duration.durationString
            case .minHeartRate:
                if let minHeartRate = run.minHeartRate {
                    cell.detailTextLabel?.text = "\(minHeartRate) bpm"
                }
            case .maxHeartRate:
                if let maxHeartRate = run.maxHeartRate {
                    cell.detailTextLabel?.text = "\(maxHeartRate) bpm"
                }
            case .averageHeartRate:
                if let averageHeartRate = run.averageHeartRate {
                    cell.detailTextLabel?.text = "\(averageHeartRate) bpm"
                }
            case .cumulativeElevationGain:
                cell.detailTextLabel?.text = String(format: "%.0f m", round(run.cumulativeElevationGain))
            }
        case 1:
            cell.textLabel?.text = NSLocalizedString("Splits", comment: "")
            cell.detailTextLabel?.text = nil
            cell.accessoryType = .disclosureIndicator
        default:
            break
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 1 && indexPath.row == 0 {
            presentSplitsViewController()
        }
    }
    
    // MARK: - Actions
    
    func presentSplitsViewController() {
        guard let splitsViewController = storyboard?.instantiateViewController(withIdentifier: "SplitsViewController") as? SplitsViewController else {
            return
        }
        
        splitsViewController.run = run
        navigationController?.pushViewController(splitsViewController, animated: true)
    }
    
}
