//
//  TodoDetailViewController+TableDelegate.swift
//  todo
//
//  Created by Alejandro Mendoza on 14/01/20.
//  Copyright © 2020 Alejandro Mendoza. All rights reserved.
//

import UIKit

extension TodosDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = HeaderView()
        let tag = TodoManager.sharedInstance.todoTagsSorted[section]
        header.headerTag = TodoManager.sharedInstance.todoTagsSorted[section]
        
        if let colorName = TodoManager.sharedInstance.getColorForTag(tag) {
            header.headerTagColor = getColorFrom(colorName)
        }
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        Constants.TodoDetailTableViewHeaderHeight
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
}
