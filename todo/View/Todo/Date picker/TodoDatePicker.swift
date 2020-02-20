//
//  TodoDatePicker.swift
//  todo
//
//  Created by Alejandro Mendoza on 14/01/20.
//  Copyright © 2020 Alejandro Mendoza. All rights reserved.
//

import UIKit

protocol TodoDatePickerDelegate: class {
    func acceptActionWasSelectedWithDate(date: Date)
    func cancelActionWasSelected()
}

class TodoDatePicker: UIView {

    @IBOutlet private weak var containerView: UIView! {
        didSet {
            containerView.layer.cornerRadius = Constants.TodoCornerRadius
        }
    }
    @IBOutlet private weak var actionsBackgroundView: UIView! {
        didSet {
            actionsBackgroundView.layer.cornerRadius = Constants.TodoCornerRadius
        }
    }
    @IBOutlet private weak var acceptActionBackground: UIView!
    @IBOutlet private weak var cancelActionBackground: UIView!
    @IBOutlet private weak var todoDatePicker: UIDatePicker!
    
    private var actionView: [UIView]?
    
    weak var delegate: TodoDatePickerDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        customInit()
    }
    
    private func customInit(){
        let bundle = Bundle(for: AddTodo.self)
        bundle.loadNibNamed(String(describing: TodoDatePicker.self), owner: self, options: nil)
        addSubview(containerView)
        containerView.frame = bounds
        containerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        setupActionsCornerRadius()
        addGestureRecognizerToActions()
        actionView = [acceptActionBackground, cancelActionBackground]
        updateUIForStyle(style: traitCollection.userInterfaceStyle)
    }
    
    private func setupActionsCornerRadius(){
        acceptActionBackground.layer.cornerRadius = Constants.TodoCornerRadius
        cancelActionBackground.layer.cornerRadius = Constants.TodoCornerRadius
    }
    
    private func addGestureRecognizerToActions(){
        let acceptTap = UITapGestureRecognizer(target: self, action: #selector(acceptActionWasSelected))
        acceptActionBackground.addGestureRecognizer(acceptTap)
        
        let cancelTap = UITapGestureRecognizer(target: self, action: #selector(cancelActionWasSelected))
        cancelActionBackground.addGestureRecognizer(cancelTap)
    }
    
    @objc private func acceptActionWasSelected(){
        let selectedDate = todoDatePicker.date
        delegate?.acceptActionWasSelectedWithDate(date: selectedDate)
    }
    
    @objc private func cancelActionWasSelected(){
        delegate?.cancelActionWasSelected()
    }
}


//MARK: - Handle UserInterfaceStyle
extension TodoDatePicker {
    private func updateUIForStyle(style: UIUserInterfaceStyle) {
        guard let actionViews = actionView else { return }
        
        switch style {
        case .light, .unspecified:
            for actionView in actionViews {
                actionView.layer.borderWidth = 0
            }
        case .dark:
            for actionView in actionViews {
                actionView.layer.borderWidth = Constants.ToolbarActionBorderWidth
            }
        @unknown default:
            assert(true, "Missing UserInterfaceStyle")
        }
    }
}


// MARK: TraitCollection
extension TodoDatePicker {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection == previousTraitCollection {
            return
        }
        
        updateUIForStyle(style: traitCollection.userInterfaceStyle)
        
    }
}
