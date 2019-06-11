//
//  ViewController.swift
//  Ranalyse
//
//  Created by Mykhailo Moiseienko on 5/11/19.
//  Copyright © 2019 Mykhailo Moiseienko. All rights reserved.
//

import UIKit

class RunsListViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var tableView: UITableView!
    
    lazy var refreshControl: UIRefreshControl! = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(loadData), for: .valueChanged)
        return refreshControl
    }()
    
    // MARK: - Properties
    
    private var runs = [Run]()
    
    // MARK: - View Controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        loadData()
    }
    
    private func setupView() {
        title = NSLocalizedString("Runs", comment: "")
        tableView.refreshControl = refreshControl
    }
    
    @objc
    private func loadData() {
        refreshControl.beginRefreshing()
        DataStore.shared.getRuns { [weak self] result in
            switch result {
            case .success(let runs):
                self?.runs = runs
                
                self?.tableView.reloadData()
                self?.refreshControl.endRefreshing()
            case .failure(let error):
                self?.showError(error)
            }
        }
    }
    
     // MARK: - Navigation
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? RunDetailsTableViewController {
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.run = runs[indexPath.row]
            }
        }
     }

}

extension RunsListViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return runs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RunsListCell", for: indexPath)
        let run = runs[indexPath.row]
        
        cell.textLabel?.text = run.name
        
        if let date = run.date {
            cell.detailTextLabel?.text = Formatter.date(date)
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
