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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTable()
        
        tableView.register(UINib(nibName: "TodoTagTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.TagCellIdentifier)
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
           return TodoManager.sharedInstance.todosTags.count
       }

       override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           
           let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TagCellIdentifier, for: indexPath)
           
           guard let masterViewCell = cell as? TodoTagTableViewCell, let tag = TodoManager.sharedInstance.tagForIndexPath(indexPath) else { return cell }
           
           masterViewCell.headerTag = tag
           
           return cell
       }
       
       override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return 45 * 1.3
       }
}
