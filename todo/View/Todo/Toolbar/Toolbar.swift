//
//  Toolbar.swift
//  todo
//
//  Created by Alejandro Mendoza on 12/01/20.
//  Copyright © 2020 Alejandro Mendoza. All rights reserved.
//

import UIKit

protocol ToolbarDelegate: class {
    func addActionWasSelected()
    func scheduleActionWasSelected()
    func discardActionWasSelected()
}

@IBDesignable
class Toolbar: UIView {

    @IBOutlet var containerView: UIView!
    @IBOutlet weak var addBackgroundView: UIView!
    @IBOutlet weak var scheduleBackgroundView: UIView!
    @IBOutlet weak var discardBackgorundView: UIView!
    
    weak var delegate: ToolbarDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        customInit()
    }
    
    func customInit(){
        let bundle = Bundle(for: AddTodo.self)
        bundle.loadNibNamed(String(describing: Toolbar.self), owner: self, options: nil)
        addSubview(containerView)
        containerView.frame = bounds
        containerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        setupActionsCornerRadius()
        addGestureRecognizerToActions()
    }
    
    func setupActionsCornerRadius(){
        addBackgroundView.layer.cornerRadius = Constants.TodoCornerRadius
        scheduleBackgroundView.layer.cornerRadius = Constants.TodoCornerRadius
        discardBackgorundView.layer.cornerRadius = Constants.TodoCornerRadius
    }
    
    func addGestureRecognizerToActions(){
        let addTap = UITapGestureRecognizer(target: self, action: #selector(addActionSelected))
        addBackgroundView.addGestureRecognizer(addTap)
        
        let scheduleTap = UITapGestureRecognizer(target: self, action: #selector(scheduleActionSelected))
        scheduleBackgroundView.addGestureRecognizer(scheduleTap)
        
        let discardTap = UITapGestureRecognizer(target: self, action: #selector(discardActionSelected))
        discardBackgorundView.addGestureRecognizer(discardTap)
    }

}

// MARK: Call to delegate
extension Toolbar {
    @objc func addActionSelected(){
        delegate?.addActionWasSelected()
    }
    @objc func scheduleActionSelected(){
        delegate?.scheduleActionWasSelected()
    }
    @objc func discardActionSelected(){
        delegate?.discardActionWasSelected()
    }
}
