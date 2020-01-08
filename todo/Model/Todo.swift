//
//  todo.swift
//  todo
//
//  Created by Alejandro Mendoza on 09/12/19.
//  Copyright © 2019 Alejandro Mendoza. All rights reserved.
//

import Foundation

struct Todo {
    var description: String
    var dateCreated: Date
    var dateScheduled: Date?
    var tagName: String
    var compleated: Bool
    let identifier: String
}


var todo1 = Todo(description: "Test", dateCreated: Date(), dateScheduled: nil, tagName: "Homework", compleated: false, identifier: "1")
var todo2 = Todo(description: "Test2", dateCreated: Date(), dateScheduled: Date(), tagName: "House", compleated: true, identifier: "2")

let someTodos = [todo1, todo2]
