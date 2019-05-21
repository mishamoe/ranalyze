//
//  UIViewController+showError.swift
//  Ranalyse
//
//  Created by Mykhailo Moiseienko on 5/21/19.
//  Copyright © 2019 Mykhailo Moiseienko. All rights reserved.
//

import UIKit

extension UIViewController {
    public func showError(_ error: Error) {
        let alert = UIAlertController(title: NSLocalizedString("Error", comment: ""),
                                      message: error.localizedDescription,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""),
                                      style: .default,
                                      handler: nil))
        present(alert, animated: true)
    }
}

