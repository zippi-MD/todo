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
    
    @IBOutlet weak var discardOptionLabel: UILabel!
    @IBOutlet weak var scheduleOptionLabel: UILabel!
    @IBOutlet weak var addOptionLabel: UILabel!
    
    
    var actionView: [UIView]?
    
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
        localizeToolbarOptions()
        actionView = [addBackgroundView, scheduleBackgroundView, discardBackgorundView]
        addGestureRecognizerToActions()
        updateUIForStyle(style: traitCollection.userInterfaceStyle)
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
    
    func localizeToolbarOptions(){
        discardOptionLabel.text = NSLocalizedString("add_todo_discard_option", comment: "Toolbar Discard Option")
        scheduleOptionLabel.text = NSLocalizedString("add_todo_schedule_option", comment: "Toolbar Schedule Option")
        addOptionLabel.text = NSLocalizedString("add_todo_add_option", comment: "Toolbar Add Option")
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

// MARK: TraitCollection
extension Toolbar {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection == previousTraitCollection {
            return
        }
        
        updateUIForStyle(style: traitCollection.userInterfaceStyle)
        
    }
}


// MARK: Handle UserInterfaceStyle
extension Toolbar {
    func updateUIForStyle(style: UIUserInterfaceStyle) {
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

