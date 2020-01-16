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
    @IBOutlet weak var dateBackgroundView: UIView!
    @IBOutlet weak var todoDateLabel: UILabel!
    @IBOutlet weak var todoBackgroundView: UIView!
    @IBOutlet weak var todoStateIndicatorImageView: UIImageView!
    @IBOutlet weak var todoLabel: UILabel!
    
    var todoDescription: String {
        set {
            todoLabel.text = newValue
        }
        
        get {
            return todoLabel.text ?? ""
        }
    }
    
    var todoTag: NSAttributedString {
        set {
            todoTagLabel.attributedText = newValue
        }
        get {
            return todoTagLabel.attributedText ?? NSAttributedString(string: "")
        }
    }
    
    private var actualTodoState: TodoState = .incomplete
    
    var todoState: TodoState {
        set {
            let indicatorImageIdentifier: String
            switch newValue {
            case .incomplete:
                indicatorImageIdentifier = "circle"
                actualTodoState = .incomplete
            case .complete:
                indicatorImageIdentifier = "checkmark.circle.fill"
                actualTodoState = .complete
            }
            todoStateIndicatorImageView.image = UIImage(systemName: indicatorImageIdentifier)
        }
        
        get {
            return actualTodoState
        }
    }
    
    var showDate: Bool {
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
