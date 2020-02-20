//
//  TodoTableViewCell.swift
//  todo
//
//  Created by Alejandro Mendoza on 15/01/20.
//  Copyright © 2020 Alejandro Mendoza. All rights reserved.
//

import UIKit

class TodoWithTagAndDateTableViewCell: UITableViewCell {
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var todoBackgroundView: UIView! {
        didSet {
            todoBackgroundView.layer.cornerRadius = Constants.TodoCornerRadius
        }
    }
    @IBOutlet private weak var todoTagLabel: UILabel!
    @IBOutlet private weak var todoDateLabel: UILabel!


    @IBOutlet private weak var todoLabel: UILabel!
    
    var todo: Todo?
    var todoDescription: String? {
        set {
            if let tag = todoTag {
                var todoDescription = newValue?.replacingOccurrences(of: tag, with: " ")
                todoDescription = todoDescription?.trimmingCharacters(in: .whitespacesAndNewlines)
                todoLabel.text = todoDescription
            }
            else {
                todoLabel.text = newValue
            }
        }
        
        get {
            return todoLabel.text ?? ""
        }
    }
    
    var todoTag: String? {
        set {
            if let tag = newValue, let location = getLocationOfTagFrom(tag, beginningWith: Constants.TagIdentifier), let tagBackgroundIdentifier = TagBackgroundColors.allCases.randomElement(), let color = UIColor(named: tagBackgroundIdentifier.rawValue) {
                
                let highlightedTag = getHighlightedTextFor(tag, withLocation: location, color: color, wide: true)
                
                todoTagLabel.attributedText = highlightedTag
            }
        }
        get {
            return todoTagLabel.text
        }
    }
    
    var todoScheduledDate: Date? {
        willSet {
            if let date = newValue {
                todoDateLabel.text = getLocalShortDateFor(date)
            }
            else {
                todoDateLabel.text = ""
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
