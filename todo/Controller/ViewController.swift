//
//  ViewController.swift
//  todo
//
//  Created by Alejandro Mendoza on 08/12/19.
//  Copyright © 2019 Alejandro Mendoza. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var table: UITableView!
    
    let todoCellIdentifier: String = "basicTodoCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.dataSource = self
        table.delegate = self
        
    }


}

