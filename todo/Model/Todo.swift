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
