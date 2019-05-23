//
//  SplitsViewController.swift
//  Ranalyse
//
//  Created by Mykhailo Moiseienko on 5/19/19.
//  Copyright © 2019 Mykhailo Moiseienko. All rights reserved.
//

import UIKit

class SplitsViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Properties
    
    var splits: [Split]!
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        assert(splits != nil)
        setupView()
    }
    
    private func setupView() {
        title = NSLocalizedString("Splits", comment: "")
    }
}

extension SplitsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return splits.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SplitTableViewCell", for: indexPath) as? SplitTableViewCell else {
            return UITableViewCell()
        }
        
        switch indexPath.section {
        case 0:
            cell.configureAsHeader()
        case 1:
            cell.configure(with: splits[indexPath.row])
        default:
            break
        }
        
        return cell
    }
}
