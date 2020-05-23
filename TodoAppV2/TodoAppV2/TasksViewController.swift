//
//  TasksViewController.swift
//  TodoAppV2
//
//  Created by Edward Barajas on 5/22/20.
//  Copyright © 2020 Edward Barajas. All rights reserved.
//

import UIKit

class TasksViewController: UIViewController {

    @IBOutlet weak var userIDLabel: UILabel!
    var userID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let uid = userID {
            userIDLabel.text = uid
        }

        // Do any additional setup after loading the view.
    }
    


}
