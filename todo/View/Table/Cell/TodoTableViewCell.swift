//
//  TodoTableViewCell.swift
//  todo
//
//  Created by Alejandro Mendoza on 16/02/20.
//  Copyright © 2020 Alejandro Mendoza. All rights reserved.
//

import UIKit

class TodoTableViewCell: UITableViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var todoBackgroundView: UIView! {
        didSet {
            todoBackgroundView.layer.cornerRadius = Constants.TodoCornerRadius
        }
    }
    @IBOutlet weak var todoLabel: UILabel!
    @IBOutlet private weak var todoDateLabel: UILabel!
    
    var todo: Todo?
    var todoTag: String?
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
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
