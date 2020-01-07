//
//  TodoTagTableViewCell.swift
//  todo
//
//  Created by Alejandro Mendoza on 06/01/20.
//  Copyright © 2020 Alejandro Mendoza. All rights reserved.
//

import UIKit

class TodoTagTableViewCell: UITableViewCell {
    
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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        TagBackgroundView.layer.cornerRadius = CornerRadius
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
