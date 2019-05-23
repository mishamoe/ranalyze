//
//  HeartRateZoneTableViewCell.swift
//  Ranalyse
//
//  Created by Mykhailo Moiseienko on 5/23/19.
//  Copyright © 2019 Mykhailo Moiseienko. All rights reserved.
//

import UIKit

class HeartRateZoneTableViewCell: UITableViewCell {
    @IBOutlet weak var zoneIndexLabel: UILabel!
    @IBOutlet weak var zoneNameLabel: UILabel!
    @IBOutlet weak var zoneRangeLabel: UILabel!
    @IBOutlet weak var timeIntervalLabel: UILabel!
    @IBOutlet weak var percentageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        zoneIndexLabel.font = UIFont.systemFont(ofSize: 12)
        zoneNameLabel.font = UIFont.systemFont(ofSize: 12)
        zoneRangeLabel.font = UIFont.systemFont(ofSize: 12)
        timeIntervalLabel.font = UIFont.systemFont(ofSize: 12)
        percentageLabel.font = UIFont.systemFont(ofSize: 12)
    }
}
