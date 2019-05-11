//
//  ViewController.swift
//  Ranalyse
//
//  Created by Mykhailo Moiseienko on 5/11/19.
//  Copyright © 2019 Mykhailo Moiseienko. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let run = Run.run(fromGPXFile: "2353588335") {
            print("Total distance: \(run.distance) meters")
            print("Total duration: \(run.duration.durationString)")
        }
    }

}
