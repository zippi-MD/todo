//
//  TodoManager.swift
//  todo
//
//  Created by Alejandro Mendoza on 06/01/20.
//  Copyright © 2020 Alejandro Mendoza. All rights reserved.
//

import Foundation

class TodoManager {
    
    static let sharedInstance = TodoManager()
    
    var todosTags = Set<String>()
    
    var todos = [Todo]() {
        didSet {
            getTodosTags()
            todoTagsSorted = Array(todosTags).sorted()
        }
    }
    
    var todosByTag = [String: [Todo]]()
    
    var numberOfSections: Int { todosTags.count }
    
    private var todoTagsSorted = [String]()
    
    private func getTodosTags() {
        for todo in todos {
            if let tag = todo.tagName {
                todosTags.insert(tag)
                
                if let _ = todosByTag[tag] {
                    todosByTag[tag]?.append(todo)
                }
                else {
                    todosByTag[tag] = [todo]
                }
                
            }
        }
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int{
        
        if todos.count == 0 { return 0 }
        
        let tagForSection = todoTagsSorted[section]
        return todosByTag[tagForSection]?.count ?? 0
    }
    
    func todoForIndexPath(_ indexPath: IndexPath) -> Todo? {
        let tag = todoTagsSorted[indexPath.section]
        return todosByTag[tag]?[indexPath.row]
    }
    
    func tagForIndexPath(_ indexPath: IndexPath) -> String? {
        if todos.count == 0 { return nil }
        return todoTagsSorted[indexPath.row]
    }
    
}
