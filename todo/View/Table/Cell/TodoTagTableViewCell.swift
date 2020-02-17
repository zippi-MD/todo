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
            if let location = getLocationOfTagFrom(newValue, beginningWith: Constants.TagIdentifier), let tagBackgroundIdentifier = TagBackgroundColors.allCases.randomElement(), let color = UIColor(named: tagBackgroundIdentifier.rawValue) {
                
                let highlightedTag = getHighlightedTextFor(newValue, withLocation: location, color: color, wide: true)
                
                TagLabel.attributedText = highlightedTag
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

    }
    
}
