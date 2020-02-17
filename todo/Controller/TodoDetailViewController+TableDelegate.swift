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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let context = fetchedResultsController.managedObjectContext
            guard let todo = TodoManager.sharedInstance.todoForIndexPath(indexPath) else { return }
            context.delete(todo)
//            tableView.deleteRows(at: [indexPath], with: .fade)
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
    
    //MARK: -Swipe Actions
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let completeAction = UIContextualAction(style: .normal, title: "") { [unowned self](_, _, _) in
            
        }
        
        completeAction.backgroundColor = UIColor(named: TagBackgroundColors.TagGreen1.rawValue)
        completeAction.image = UIImage(systemName: "checkmark")
        
        return UISwipeActionsConfiguration(actions: [completeAction])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let trashAction = UIContextualAction(style: .normal, title: "") { [unowned self](_, _, _) in
            
        }
        
        trashAction.backgroundColor = UIColor(named: TagBackgroundColors.TagRed1.rawValue)
        trashAction.image = UIImage(systemName: "trash")
        
        return UISwipeActionsConfiguration(actions: [trashAction])
    }
}
