//
//  SettingsViewController.swift
//  Ranalyse
//
//  Created by Mykhailo Moiseienko on 5/21/19.
//  Copyright © 2019 Mykhailo Moiseienko. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    enum Section {
        case userData
        
        var rows: [Row] {
            switch self {
            case .userData:
                return [.maxHeartRate]
            }
        }
    }
    
    enum Row {
        case maxHeartRate
    }
    
    // MARK: - Outlets
    
    @IBOutlet private weak var tableView: UITableView!
    
    lazy var refreshControl: UIRefreshControl! = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(loadData), for: .valueChanged)
        return refreshControl
    }()
    
    // MARK: - Properties
    
    let sections: [Section] = [.userData]
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        loadData()
    }
    
    private func setupView() {
        title = NSLocalizedString("Settings", comment: "")
        tableView.refreshControl = refreshControl
    }
    
    @objc
    private func loadData() {
        let group = DispatchGroup()
        
        group.enter()
        updateMaxHeartRate() {
            group.leave()
        }
        
        group.notify(queue: .main) { [weak self] in
            self?.tableView.reloadData()
            self?.refreshControl.endRefreshing()
        }
    }
    
    private func updateMaxHeartRate(_ completion: @escaping () -> Void) {
        DataStore.shared.getMaxHeartRate { result in
            if let maxHeartRate = try? result.get() {
                UserDefaults.set(value: maxHeartRate, forKey: .maxHeartRate)
            }
            
            completion()
        }
    }
    
    /*
    private func presentActions(for row: Row) {
        let actionSheet = UIAlertController(title: NSLocalizedString("Actions", comment: ""),
                                      message: NSLocalizedString("Select the action you would like to perform", comment: ""),
                                      preferredStyle: .actionSheet)
        
        switch row {
        case .maxHeartRate:
            let updateAction = UIAlertAction(title: NSLocalizedString("Update", comment: ""), style: .default) { [weak self] _ in
                self?.updateMaxHeartRate()
            }
            actionSheet.addAction(updateAction)
        }
        
        actionSheet.addAction(
            UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel)
        )
        
        present(actionSheet, animated: true)
    }
    */
}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = sections[indexPath.section].rows[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsTableViewCell", for: indexPath) as! SettingsTableViewCell
        
        switch row {
        case .maxHeartRate:
            cell.textLabel?.text = NSLocalizedString("Max Heart Rate", comment: "")
            
            if let maxHeartRate: Int = UserDefaults.get(key: .maxHeartRate) {
                cell.detailTextLabel?.text = Formatter.heartRate(maxHeartRate)
            } else {
                cell.detailTextLabel?.text = NSLocalizedString("N/A", comment: "")
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch sections[section] {
        case .userData:
            return NSLocalizedString("User Data", comment: "")
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
//        presentActions(for: sections[indexPath.section].rows[indexPath.row])
    }
}
