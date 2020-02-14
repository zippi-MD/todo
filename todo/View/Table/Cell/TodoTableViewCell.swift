//
//  TodoTableViewCell.swift
//  todo
//
//  Created by Alejandro Mendoza on 15/01/20.
//  Copyright © 2020 Alejandro Mendoza. All rights reserved.
//

import UIKit

enum TodoState {
    case complete
    case incomplete
}

class TodoTableViewCell: UITableViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var todoTagLabel: UILabel!
    @IBOutlet weak var dateBackgroundView: UIView! {
        didSet {
            dateBackgroundView.layer.cornerRadius = Constants.TodoCornerRadius
        }
    }
    @IBOutlet weak var todoDateLabel: UILabel!
    @IBOutlet weak var todoBackgroundView: UIView!

    @IBOutlet weak var todoLabel: UILabel!
    @IBOutlet weak var dateHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var todoTagHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var dateTopConstraint: NSLayoutConstraint!
    
    var todo: Todo?
    var todoDescription: String? {
        set {
            if let tag = todoTag {
                todoLabel.text = newValue?.replacingOccurrences(of: tag, with: " ")
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
                showDate = true
                todoDateLabel.text = getLocalShortDateFor(date)
            }
            else {
                showDate = false
            }
        }
    }
    
    private var actualTodoState: TodoState = .incomplete
    
    var todoState: TodoState {
        set {
            switch newValue {
            case .incomplete:
                
                actualTodoState = .incomplete
            case .complete:
                
                actualTodoState = .complete
            }
        }
        
        get {
            return actualTodoState
        }
    }
    
    private var showDate: Bool {
        set {
            dateBackgroundView.isHidden = !newValue
        }
        get {
            return !dateBackgroundView.isHidden
        }
    }
    
    var showTag: Bool {
        set {
            todoTagLabel.isHidden = !newValue
        }
        get {
            return !todoTagLabel.isHidden
        }
    }
    
    var hideDateAndTag: Bool = false {
        willSet {
            if newValue {
                todoTagHeightConstraint.constant = 0
                dateHeightConstraint.constant = 0
                dateTopConstraint.constant = 0
            }
            else {
                todoTagHeightConstraint.constant = 20
                dateHeightConstraint.constant = 25
                dateTopConstraint.constant = 8
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
