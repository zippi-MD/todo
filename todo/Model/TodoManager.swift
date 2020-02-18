//
//  TodoManager.swift
//  todo
//
//  Created by Alejandro Mendoza on 06/01/20.
//  Copyright © 2020 Alejandro Mendoza. All rights reserved.
//

import Foundation

enum SortOptions: String {
    case ByTag = "By #'s"
    case ByDateCreated = "Created"
    case ByDateScheduled = "Scheduled"
}

protocol TodoManagerDelegate: class {
    func didFinishSortingTodos()
}

class TodoManager {
    
    static let sharedInstance = TodoManager()
    
    weak var delegate: TodoManagerDelegate?
    var sortTodosBy: SortOptions = .ByTag
    
    var todosTags = Set<String>()
    
    var todos = [Todo]() {
        didSet {
            getTodosTags()
            todoTagsSorted = Array(todosTags).sorted()
            sortTodos()
        }
    }
    
    var todosByTag = [String: [Todo]]()
    
    var numberOfSections: Int {
        switch sortTodosBy {
        case .ByTag:
            return todosTags.count
        case .ByDateCreated, .ByDateScheduled:
            return 1

        }
    }
    
    private(set) var todoTagsSorted = [String]()
    
    private var todosSortedByDateScheduled = [Todo]()
    private var todosSortedByDateCreated = [Todo]()
    private var todosSortedByTag = [String: [Todo]]()
    
    private func getTodosTags() {
        todosTags.removeAll(keepingCapacity: true)
        for todo in todos {
            let tag = todo.tagName ?? "#Something"
            todosTags.insert(tag)
        
            if let _ = todosByTag[tag] {
                todosByTag[tag]?.append(todo)
            }
            else {
                todosByTag[tag] = [todo]
            }
        }
    }
    
    private func sortTodos(){
        
        todosSortedByDateCreated = todos.sorted(by: { (lhs, rhs) -> Bool in
            if let lhsDate = lhs.dateCreation, let rhsDate = rhs.dateCreation {
                return lhsDate < rhsDate
            }
            return true
        })
        
        
        var todosWithScheduleDate = todos.compactMap({ (todo) -> Todo? in
            if let _ = todo.dateScheduled {
                return todo
            }
            else {
                return nil
            }
        })
        
        todosWithScheduleDate.sort(by: { (lhs, rhs) -> Bool in
            if let lhsDate = lhs.dateScheduled, let rhsDate = rhs.dateScheduled {
                return lhsDate < rhsDate
            }
            return true
        })
        
        var todosWithoutScheduleDate = todos.compactMap({ (todo) -> Todo? in
            if let _ = todo.dateScheduled {
                return nil
            }
            return todo
        })
        
        todosWithoutScheduleDate = todosWithoutScheduleDate.sorted(by: { (lhs, rhs) -> Bool in
            if let lhsDate = lhs.dateCreation, let rhsDate = rhs.dateCreation {
                return lhsDate < rhsDate
            }
            return true
        })
        
        todosSortedByDateScheduled = todosWithScheduleDate + todosWithoutScheduleDate
        
        todosSortedByTag.removeAll(keepingCapacity: true)
        for todo in todosSortedByDateScheduled {
            if let tag = todo.tagName {
                if let _ = todosSortedByTag[tag] {
                    todosSortedByTag[tag]?.append(todo)
                }
                else {
                    todosSortedByTag[tag] = [todo]
                }
            }
            else {
                if let _ = todosSortedByTag["#Something"] {
                    todosSortedByTag["#Something"]?.append(todo)
                }
                else {
                    todosSortedByTag["#Something"] = [todo]
                }
            }
        }
        
        delegate?.didFinishSortingTodos()
        
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int{
        
        if todos.count == 0 { return 0 }
        
        switch sortTodosBy {
            
        case .ByTag:
            let tagForSection = todoTagsSorted[section]
            return todosSortedByTag[tagForSection]?.count ?? 0
        case .ByDateCreated:
            return todos.count
        case .ByDateScheduled:
            return todos.count
        
        }
        
    }
    
    func todoForIndexPath(_ indexPath: IndexPath) -> Todo? {
        switch sortTodosBy {
            
        case .ByTag:
            let tag = todoTagsSorted[indexPath.section]
            return todosSortedByTag[tag]?[indexPath.row]
        case .ByDateCreated:
            return todosSortedByDateCreated[indexPath.row]
        case .ByDateScheduled:
            return todosSortedByDateScheduled[indexPath.row]

        }
    }
    
    func tagForIndexPath(_ indexPath: IndexPath) -> String? {
        
        if todos.count == 0 { return nil }
        
        switch sortTodosBy {
            
        case .ByTag:
            return todoTagsSorted[indexPath.row]
        case .ByDateCreated:
            return nil
        case .ByDateScheduled:
            return nil

        }
        
        
        
    }
    
    func getColorForTag(_ tag: String) -> TagBackgroundColors? {
        if todosTags.contains(tag), let tagColor = todosByTag[tag]?.first?.tagColor {
            return TagBackgroundColors(rawValue: tagColor)
        }
        else {
            return nil
        }
    }
    
    func getStringToShareForTodosWithTag(_ tag: String) -> String? {
        guard let todos = todosSortedByTag[tag] else { return nil }

        var shareString = "\(tag)\n"
        
        for todo in todos {
            shareString += "- "
            shareString += todo.compleated ? "✅ " : ""
            
            shareString += todo.todoDescription?.replacingOccurrences(of: tag, with: " ") ?? " "
            
            if let todoScheduleDate = todo.dateScheduled {
                shareString += "[\(getLocalShortDateFor(todoScheduleDate))]"
            }
            
            shareString += "\n"
            
        }
        
        return shareString
    }
}
