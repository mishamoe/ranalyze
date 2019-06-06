//
//  LoginViewController.swift
//  Ranalyse
//
//  Created by Mykhailo Moiseienko on 6/6/19.
//  Copyright © 2019 Mykhailo Moiseienko. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        DataStore.shared.dataService.stravaAPI.authenticate { [weak self] error in
            if let error = error {
                self?.showError(error)
                return
            }
            
            // Handle successful log in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let viewController = storyboard.instantiateInitialViewController() {
                self?.present(viewController, animated: true)
            }
        }
    }

}
