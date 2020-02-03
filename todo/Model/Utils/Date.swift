//
//  Date.swift
//  todo
//
//  Created by Alejandro Mendoza on 24/01/20.
//  Copyright © 2020 Alejandro Mendoza. All rights reserved.
//

import Foundation

func getLocalShortDateFor(_ date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .short
    return dateFormatter.string(from: date)
}
