//
//  ViewController+DataSource.swift
//  todo
//
//  Created by Alejandro Mendoza on 17/12/19.
//  Copyright © 2019 Alejandro Mendoza. All rights reserved.
//

import UIKit

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: todoCellIdentifier, for: indexPath)
        
        return cell
    }
    
    
}
