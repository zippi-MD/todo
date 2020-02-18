//
//  TodoDetailViewController+TableDelegate.swift
//  todo
//
//  Created by Alejandro Mendoza on 14/01/20.
//  Copyright © 2020 Alejandro Mendoza. All rights reserved.
//

import UIKit

extension TodosDetailViewController: UITableViewDelegate {
    
    //MARK: -Table Header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        switch detailCompactSelectedSort {

        case .ByTag:
            let header = HeaderView()
            let tag = TodoManager.sharedInstance.todoTagsSorted[section]
            header.headerTag = TodoManager.sharedInstance.todoTagsSorted[section]
            
            if let colorName = TodoManager.sharedInstance.getColorForTag(tag) {
                header.headerTagColor = getColorFrom(colorName)
            }
            
            return header
            
        case .ByDateCreated:
            return nil
            
        case .ByDateScheduled:
            return nil

        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        switch detailCompactSelectedSort {

        case .ByTag:
            return Constants.TodoDetailTableViewHeaderHeight
            
        case .ByDateCreated:
            return 0
            
        case .ByDateScheduled:
            return 0

        }
        
    }
    
    
    //MARK: -Table Footer
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerSectionView = UIView()
        footerSectionView.backgroundColor = UIColor.clear
        return footerSectionView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == TodoManager.sharedInstance.numberOfSections - 1 {
            return 80.0
        }
        return 4.0
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        TodoManager.sharedInstance.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

    
    
    //MARK: -Swipe Actions
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        guard let todo = TodoManager.sharedInstance.todoForIndexPath(indexPath) else { return nil }
        
        let completeAction = UIContextualAction(style: .normal, title: "") { [unowned self](_, _, completionHandler) in
            let context = self.fetchedResultsController.managedObjectContext
            
            do {
                let todoToUpdate = try? context.existingObject(with: todo.objectID) as? Todo
                todoToUpdate?.compleated.toggle()
                try context.save()
            } catch
            {
                let nserror = error as NSError
                assert(true, "\(nserror.localizedDescription)")
            }

            completionHandler(true)
        }
        
        if todo.compleated {
            completeAction.backgroundColor = UIColor(named: TagBackgroundColors.TagRed1.rawValue)
            completeAction.image = UIImage(systemName: "xmark.circle.fill")
        }
        else {
            completeAction.backgroundColor = UIColor(named: TagBackgroundColors.TagGreen1.rawValue)
            completeAction.image = UIImage(systemName: "checkmark.circle.fill")
        }
        
        
        return UISwipeActionsConfiguration(actions: [completeAction])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let trashAction = UIContextualAction(style: .destructive, title: "") { [unowned self](_, _, completionHandler) in
            let context = self.fetchedResultsController.managedObjectContext
            guard let todo = TodoManager.sharedInstance.todoForIndexPath(indexPath) else { return }
            context.delete(todo)
            do {
                try context.save()
            } catch
            {
                let nserror = error as NSError
                assert(true, "\(nserror.localizedDescription)")
            }
            
            completionHandler(true)
        }
        
        trashAction.backgroundColor = UIColor(named: TagBackgroundColors.TagRed2.rawValue)
        trashAction.image = UIImage(systemName: "trash.circle.fill")
        
        return UISwipeActionsConfiguration(actions: [trashAction])
    }
}
