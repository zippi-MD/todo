//
//  TodoTagTableViewHeader.swift
//  todo
//
//  Created by Alejandro Mendoza on 06/01/20.
//  Copyright © 2020 Alejandro Mendoza. All rights reserved.
//

import UIKit

class TodoTagTableViewHeader: UIView {

    @IBOutlet weak var HeaderBackgroundView: UIView!
    @IBOutlet weak var TagBackgroundView: UIView!
    @IBOutlet weak var TagLabel: UILabel!
    
    var headerTag: String {
        set {
            TagLabel.text = "# \(newValue)"
        }
        get {
            let tagValue = TagLabel.text!
            return String(tagValue.dropFirst())
        }
    }
    
}
