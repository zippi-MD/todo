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
        
        if traitCollection.horizontalSizeClass == .compact {
            switch detailCompactSelectedSort {
            case .ByTag:
                return 55.0
            case .ByDateCreated, .ByDateScheduled:
                return UITableView.automaticDimension
            }
        }
        else {
            return 25.0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.DetailTodoCellIdentifier, for: indexPath)
        guard let todoCell = cell as? TodoTableViewCell, let todo = TodoManager.sharedInstance.todoForIndexPath(indexPath) else { return cell }
        
        if traitCollection.horizontalSizeClass == UIUserInterfaceSizeClass.compact {
            switch detailCompactSelectedSort {
            case .ByTag:
                todoCell.showTag = false
            case .ByDateCreated:
                todoCell.showTag = true
            case .ByDateScheduled:
                todoCell.showTag = true
            }
        }
        
        if let scheduledDate = todo.dateScheduled {
            todoCell.todoScheduledDate = scheduledDate
            todoCell.hideDateAndTag = false
        }
        else {
            todoCell.todoScheduledDate = nil
            
            todoCell.hideDateAndTag = !todoCell.showTag ? true : false
        }
        
        todoCell.todo = todo
        todoCell.todoTag = todo.tagName
        todoCell.todoDescription = todo.todoDescription
        todoCell.todoScheduledDate = todo.dateScheduled
        
        return todoCell
    }
    
    
}
