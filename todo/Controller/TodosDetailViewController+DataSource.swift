//
//  TodosDetailViewController+DataSource.swift
//  todo
//
//  Created by Alejandro Mendoza on 14/01/20.
//  Copyright © 2020 Alejandro Mendoza. All rights reserved.
//

import UIKit

extension TodosDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TodoManager.sharedInstance.numberOfRowsInSection(section)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.DetailTodoCellIdentifier, for: indexPath)
        guard let todoCell = cell as? TodoWithTagAndDateTableViewCell, let todo = TodoManager.sharedInstance.todoForIndexPath(indexPath) else { return cell }
        
        todoCell.todo = todo
        todoCell.todoTag = todo.tagName
        todoCell.todoDescription = todo.todoDescription
        todoCell.todoScheduledDate = todo.dateScheduled
        
        return todoCell
    }
    
    
}
