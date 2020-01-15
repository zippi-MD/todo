//
//  TodoDatePicker.swift
//  todo
//
//  Created by Alejandro Mendoza on 14/01/20.
//  Copyright © 2020 Alejandro Mendoza. All rights reserved.
//

import UIKit

protocol TodoDatePickerDelegate: class {
    func acceptActionWasSelected()
    func cancelActionWasSelected()
}

class TodoDatePicker: UIView {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var acceptActionBackground: UIView!
    
    @IBOutlet weak var cancelActionBackground: UIView!
    
    let actionsCornerRadius: CGFloat = 7.0
    
    weak var delegate: TodoDatePickerDelegate?
    
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
        bundle.loadNibNamed(String(describing: TodoDatePicker.self), owner: self, options: nil)
        addSubview(containerView)
        containerView.frame = bounds
        containerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        setupActionsCornerRadius()
        addGestureRecognizerToActions()
    }
    
    func setupActionsCornerRadius(){
        acceptActionBackground.layer.cornerRadius = actionsCornerRadius
        cancelActionBackground.layer.cornerRadius = actionsCornerRadius
    }
    
    func addGestureRecognizerToActions(){
        let acceptTap = UITapGestureRecognizer(target: self, action: #selector(acceptActionWasSelected))
        acceptActionBackground.addGestureRecognizer(acceptTap)
        
        let cancelTap = UITapGestureRecognizer(target: self, action: #selector(cancelActionWasSelected))
        cancelActionBackground.addGestureRecognizer(cancelTap)
    }
    
    @objc func acceptActionWasSelected(){
        delegate?.acceptActionWasSelected()
    }
    
    @objc func cancelActionWasSelected(){
        delegate?.cancelActionWasSelected()
    }
}


