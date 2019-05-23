//
//  HeartRateZonesViewController.swift
//  Ranalyse
//
//  Created by Mykhailo Moiseienko on 5/23/19.
//  Copyright © 2019 Mykhailo Moiseienko. All rights reserved.
//

import UIKit

class HeartRateZonesViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Properties
    
    var heartRateAnalysis: HeartRateAnalysis!
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        assert(heartRateAnalysis != nil)
        setupView()
    }
    
    private func setupView() {
        title = NSLocalizedString("Heart Rate Zones", comment: "")
    }

}

extension HeartRateZonesViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return HeartRateZone.all.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HeartRateZoneTableViewCell", for: indexPath) as? HeartRateZoneTableViewCell else {
            return UITableViewCell()
        }
        
        let zone = HeartRateZone.all[indexPath.row]
        let zoneRange = zone.range(for: heartRateAnalysis.maxHeartRate)
        let timeInterval = heartRateAnalysis.timeInterval(for: zone)
        let percentage = heartRateAnalysis.percentage(of: zone)
        
        cell.zoneIndexLabel.text = "Z\(zone.rawValue)"
        cell.zoneNameLabel.text = zone.name
        cell.zoneRangeLabel.text = Formatter.range(zoneRange)
        cell.timeIntervalLabel.text = timeInterval > 0 ? Formatter.duration(timeInterval) : "-"
        cell.percentageLabel.text = String(format: "%.1f%%", percentage)
        
        return cell
    }
}

