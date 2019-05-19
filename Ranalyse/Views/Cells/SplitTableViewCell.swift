//
//  SplitTableViewCell.swift
//  Ranalyse
//
//  Created by Mykhailo Moiseienko on 5/19/19.
//  Copyright © 2019 Mykhailo Moiseienko. All rights reserved.
//

import UIKit

class SplitTableViewCell: UITableViewCell {

    @IBOutlet private weak var indexLabel: UILabel!
    @IBOutlet private weak var paceLabel: UILabel!
    @IBOutlet private weak var elevationLabel: UILabel!
    @IBOutlet private weak var heartRateLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        indexLabel.text = nil
        paceLabel.text = nil
        elevationLabel.text = nil
        heartRateLabel.text = nil
    }

    func configureAsHeader() {
        indexLabel.text = NSLocalizedString("KM", comment: "")
        paceLabel.text = NSLocalizedString("PACE", comment: "")
        elevationLabel.text = NSLocalizedString("ELEVATION", comment: "")
        heartRateLabel.text = NSLocalizedString("HEART RATE", comment: "")
        
        indexLabel.font = UIFont.boldSystemFont(ofSize: 12)
        paceLabel.font = UIFont.boldSystemFont(ofSize: 12)
        elevationLabel.font = UIFont.boldSystemFont(ofSize: 12)
        heartRateLabel.font = UIFont.boldSystemFont(ofSize: 12)
    }
    
    func configure(with split: Split) {
        if split.distance >= 1_000 {
            indexLabel.text = "\(split.index)"
        } else {
            indexLabel.text = String(format: "%.1f", split.distance / 1_000.0)
        }
        
        paceLabel.text = split.pace.paceString
        
        // TODO: implement calculation of split's elevation
        elevationLabel.text = NSLocalizedString("N/A", comment: "")
        
        // TODO: implement calculation of split's average heart rate
        heartRateLabel.text = NSLocalizedString("N/A", comment: "")
        
        indexLabel.font = UIFont.systemFont(ofSize: 17)
        paceLabel.font = UIFont.systemFont(ofSize: 17)
        elevationLabel.font = UIFont.systemFont(ofSize: 17)
        heartRateLabel.font = UIFont.systemFont(ofSize: 17)
    }

}
