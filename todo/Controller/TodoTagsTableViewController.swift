//
//  TodoTagsTableViewController.swift
//  todo
//
//  Created by Alejandro Mendoza on 06/01/20.
//  Copyright © 2020 Alejandro Mendoza. All rights reserved.
//

import UIKit

class TodoTagsTableViewController: UITableViewController {

    @IBOutlet var table: UITableView!
    
    var selectedRowIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTable()
        tableView.register(UINib(nibName: "TodoTagTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.TagCellIdentifier)
        
        TodoManager.sharedInstance.masterDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: UITableView.ScrollPosition.none)
    }
    
    func setUpTable(){
        table.separatorColor = .clear
    }

}

// MARK: - Table view data source
extension TodoTagsTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
           return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return TodoManager.sharedInstance.todosTags.count + 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
       let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TagCellIdentifier, for: indexPath)
        
        let tagIndexPath = IndexPath(row: indexPath.row - 1, section: indexPath.section)
        let tag: String?
        
        if tagIndexPath.row < 0 {
            tag = "#All"
        }
        else {
            tag = TodoManager.sharedInstance.tagForIndexPath(tagIndexPath)
        }
       
       guard let masterViewCell = cell as? TodoTagTableViewCell, let headerTag = tag else { return cell }
       
       masterViewCell.headerTag = headerTag
       
       return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 45 * 1.3
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0, indexPath.row == 0 {
            TodoManager.sharedInstance.focusOption = .All
        }
        else {
            let selectedRowIndexPath = IndexPath(row: indexPath.row - 1, section: indexPath.section)
            if let tag = TodoManager.sharedInstance.tagForIndexPath(selectedRowIndexPath) {
                TodoManager.sharedInstance.focusOption = .Tag(tag)
            }
        }
    }
}

extension TodoTagsTableViewController: TodoManagerDelegate {
    func didChangeFocusTo(option: FocusOptions) {
    }
    
    func didFinishSortingTodos() {
        tableView.reloadData()
    }
    
}
