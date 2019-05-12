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
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return details.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RunCell", for: indexPath)
        let detail = details[indexPath.row]
        
        cell.textLabel?.text = detail.title
        
        switch detail {
        case .distance:
            cell.detailTextLabel?.text = String(format: "%.2f km", run.distance / 1000)
        case .duration:
            cell.detailTextLabel?.text = run.duration.durationString
        case .minHeartRate:
            cell.detailTextLabel?.text = "\(run.minHeartRate) bpm"
        case .maxHeartRate:
            cell.detailTextLabel?.text = "\(run.maxHeartRate) bpm"
        case .averageHeartRate:
            cell.detailTextLabel?.text = "\(run.averageHeartRate) bpm"
        case .cumulativeElevationGain:
            cell.detailTextLabel?.text = "\(round(run.cumulativeElevationGain)) m"
        }

        return cell
    }
    
}
