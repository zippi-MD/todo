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
    
    init() {
        todosTags = getTodosTags()
    }
    
    
    private func getTodosTags() -> Set<String> {
        var tags = Set<String>()
        
        for todo in someTodos {
            tags.insert(todo.tagName)
        }
        
        return tags
    }
}
