//
//  TodoManager.swift
//  todo
//
//  Created by Alejandro Mendoza on 06/01/20.
//  Copyright © 2020 Alejandro Mendoza. All rights reserved.
//

import Foundation

enum SortOptions: String {
    case ByTag = "segment_tags_option"
    case ByDateCreated = "segment_created_option"
    case ByDateScheduled = "segment_scheduled_option"
}

enum FocusOptions {
    case All
    case Tag(String)
}

protocol TodoManagerDelegate: class {
    func didFinishSortingTodos()
    func didChangeFocusTo(option: FocusOptions)
}

class TodoManager {
    
    static let sharedInstance = TodoManager()
    weak var detailDelegate: TodoManagerDelegate?
    weak var masterDelegate: TodoManagerDelegate?
    var sortTodosBy: SortOptions = .ByTag
    
    var focusOption: FocusOptions = .All {
        didSet {
            detailDelegate?.didChangeFocusTo(option: focusOption)
        }
    }
    
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
            
            switch focusOption {
                
            case .All:
                return todosTags.count
                
            case .Tag(_):
                return 1
                
            }
            
        case .ByDateCreated, .ByDateScheduled:
            return 1

        }
    }
    
    private(set) var todoTagsSorted = [String]()
    
    private var todosSortedByDateScheduled = [Todo]()
    private var todosSortedByDateCreated = [Todo]()
    private var todosSortedByTagAndDateScheduled = [String: [Todo]]()
    private var todosSortedByTagAndDateCreated = [String: [Todo]]()
    
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
        
        todosSortedByTagAndDateScheduled.removeAll(keepingCapacity: true)
        for todo in todosSortedByDateScheduled {
            if let tag = todo.tagName {
                if let _ = todosSortedByTagAndDateScheduled[tag] {
                    todosSortedByTagAndDateScheduled[tag]?.append(todo)
                }
                else {
                    todosSortedByTagAndDateScheduled[tag] = [todo]
                }
            }
            else {
                if let _ = todosSortedByTagAndDateScheduled["#Something"] {
                    todosSortedByTagAndDateScheduled["#Something"]?.append(todo)
                }
                else {
                    todosSortedByTagAndDateScheduled["#Something"] = [todo]
                }
            }
        }
        
        todosSortedByTagAndDateCreated.removeAll(keepingCapacity: true)
        for todo in todosSortedByDateCreated {
            if let tag = todo.tagName {
                if let _ = todosSortedByTagAndDateCreated[tag]{
                    todosSortedByTagAndDateCreated[tag]?.append(todo)
                }
                else {
                    todosSortedByTagAndDateCreated[tag] = [todo]
                }
            }
            else {
                if let _ = todosSortedByTagAndDateCreated["#Something"] {
                    todosSortedByTagAndDateCreated["#Something"]?.append(todo)
                }
                else {
                    todosSortedByTagAndDateCreated["#Something"]?.append(todo)
                }
            }
        }
        
        detailDelegate?.didFinishSortingTodos()
        masterDelegate?.didFinishSortingTodos()
        
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int{
        
        if todos.count == 0 { return 0 }
        
        switch sortTodosBy {
            
        case .ByTag:
            
            switch focusOption {
            case .All:
                let tagForSection = todoTagsSorted[section]
                return todosSortedByTagAndDateScheduled[tagForSection]?.count ?? 0
                
            case .Tag(let tag):
                return todosSortedByTagAndDateScheduled[tag]?.count ?? 0
            }

        case .ByDateScheduled:
            
            switch focusOption {
            case .All:
                return todos.count
                
            case .Tag(let tag):
                return todosSortedByTagAndDateScheduled[tag]?.count ?? 0
            }
            
        case .ByDateCreated:
            switch focusOption {
            case .All:
                return todos.count
                
            case .Tag(let tag):
                return todosSortedByTagAndDateCreated[tag]?.count ?? 0
            }
            
        
        }
        
    }
    
    func todoForIndexPath(_ indexPath: IndexPath) -> Todo? {
        switch sortTodosBy {
            
        case .ByTag:
            
            switch focusOption {
            case .All:
                let tag = todoTagsSorted[indexPath.section]
                return todosSortedByTagAndDateScheduled[tag]?[indexPath.row]
                
            case .Tag(let tag):
                return todosSortedByTagAndDateScheduled[tag]?[indexPath.row]
            }
            
            
        case .ByDateCreated:
            
            switch focusOption {
            case .All:
               return todosSortedByDateCreated[indexPath.row]
                
            case .Tag(let tag):
                return todosSortedByTagAndDateCreated[tag]?[indexPath.row]
            }
            
        case .ByDateScheduled:
            
            switch focusOption {
            case .All:
                return todosSortedByDateScheduled[indexPath.row]
                
            case .Tag(let tag):
                return todosSortedByTagAndDateScheduled[tag]?[indexPath.row]
            }

        }
    }
    
    func headerForSection(_ section: Int) -> String {
        switch focusOption {
        case .All:
            return todoTagsSorted[section]
        case .Tag(let tag):
            return tag
        }
    }
    
    func tagForIndexPath(_ indexPath: IndexPath) -> String? {
        
        if todos.count == 0 { return nil }
        
        return todoTagsSorted[indexPath.row]
        
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
        guard let todos = todosSortedByTagAndDateScheduled[tag] else { return nil }

        var shareString = "\(tag)\n"
        
        for todo in todos {
            shareString += "- "
            shareString += todo.compleated ? "✅" : ""
            
            shareString += todo.todoDescription?.replacingOccurrences(of: tag, with: " ") ?? " "
            
            if let todoScheduleDate = todo.dateScheduled {
                shareString += "[\(getLocalShortDateFor(todoScheduleDate))]"
            }
            
            shareString += "\n"
            
        }
        
        return shareString
    }
}
