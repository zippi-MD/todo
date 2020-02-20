//
//  TodoTagTableViewCell.swift
//  todo
//
//  Created by Alejandro Mendoza on 06/01/20.
//  Copyright © 2020 Alejandro Mendoza. All rights reserved.
//

import UIKit

class TodoTagTableViewCell: UITableViewCell {
    
    @IBOutlet weak var contentBackgroundView: UIView!
    @IBOutlet weak var TagBackgroundView: UIView!
    @IBOutlet weak var TagLabel: UILabel!
    
    var headerTag: String {
        set {
            if let location = getLocationOfTagFrom(newValue, beginningWith: Constants.TagIdentifier) {
                
                let tagColorName = TodoManager.sharedInstance.getColorForTag(newValue) ?? TagBackgroundColors.TagPink1
                let tagColor = getColorFrom(tagColorName)
                let highlightedTag = getHighlightedTextFor(newValue, withLocation: location, color: tagColor, wide: true)
                
                TagLabel.attributedText = highlightedTag
                
            }
            else {
                TagLabel.text = ""
            }
        }
        get {
            let tagValue = TagLabel.text!
            return String(tagValue.dropFirst())
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        let colorName = selected ? "Cell-Background" : "TableBackground"
        
        if let selectedColor = UIColor(named: colorName) {
            contentBackgroundView.backgroundColor = selectedColor
        }
    }
    
}
