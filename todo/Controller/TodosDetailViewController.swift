//
//  TodosDetailViewController.swift
//  todo
//
//  Created by Alejandro Mendoza on 07/01/20.
//  Copyright © 2020 Alejandro Mendoza. All rights reserved.
//

import UIKit

class TodosDetailViewController: UIViewController {

    
    @IBOutlet weak var addTodoView: AddTodo!
    @IBOutlet weak var toolbarView: Toolbar!
    @IBOutlet weak var toolbarBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var addTodoBottomConstraint: NSLayoutConstraint!
    
    let keyboardHandler = KeyboardEvents()
    
    var actualTodoDetailState: TodoState = .discard
    var actualKeyboardState: KeyboardState = .hidden
    
    override func viewDidLoad() {
        super.viewDidLoad()
        keyboardHandler.registerForKeyboardEvents()
        keyboardHandler.delegate = self
        toolbarView.delegate = self
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        keyboardHandler.unregisterFromKeyboardEvents()
    }
    @IBAction func activateAddTodo(_ sender: Any) {
        actualTodoDetailState = .present
        let animationDuration: TimeInterval = 0.25
        addTodoView.alpha = 0
        addTodoView.isHidden = false
        
        UIView.animate(withDuration: animationDuration, animations: {
            self.addTodoView.alpha = 1
            self.addTodoBottomConstraint.constant = self.view.frame.height * 0.4
            self.view.layoutIfNeeded()
        }) { (_) in
            self.addTodoView.todoTextView.becomeFirstResponder()
        }
    }
    
}

// MARK: - Handle Keyboard Events
extension TodosDetailViewController: KeyboardHandlingDelegate {
    func keyboardWillShow(_ notification: Notification) {
        
        toolbarView.isHidden = false
        toolbarView.alpha = 0
        
        let keyboardSize = notification.keyboardSize
        
        if let keyboardHeight = keyboardSize?.height, let animationDuration = notification.keyboardAnimationDuration {
            UIView.animate(withDuration: animationDuration) {
                self.toolbarView.alpha = 1
                self.toolbarBottomConstraint.constant = keyboardHeight - 35.0
                self.view.layoutIfNeeded()
            }
        }
        
    }
    
    func keyboardDidShow(_ notification: Notification) {
        
    }
    
    func keyboardWillHide(_ notification: Notification) {
        if actualTodoDetailState == .discard {
            UIView.animate(withDuration: 0.25) {
                self.toolbarView.alpha = 0
                self.toolbarBottomConstraint.constant = 0
                self.view.layoutIfNeeded()
            }
        }
        
        else if actualTodoDetailState == .schedule {
            let animationDuration = notification.keyboardAnimationDuration ?? 0.25
            UIView.animate(withDuration: animationDuration, animations: {
                self.toolbarView.alpha = 0
                self.toolbarBottomConstraint.constant = 0
            }) { (_) in
                 
            }
        }
    }
    
    func keyboardDidHide(_ notification: Notification) {
        
    }
    
    func keyboardWillChangeFrame(_ notification: Notification) {
        
    }
    
    func keyboardDidChangeFrame(_ notification: Notification) {
        
    }
    
    
}

// MARK: - Handle Toolbar Events
extension TodosDetailViewController: ToolbarDelegate {
    func addActionWasSelected() {

    }
    
    func scheduleActionWasSelected() {
        actualTodoDetailState = .schedule
        
        addTodoView.todoTextView.resignFirstResponder()
    }
    
    func discardActionWasSelected() {
        
        actualTodoDetailState = .discard
        let animationDuration: TimeInterval = 0.25
        
        UIView.animate(withDuration: animationDuration, animations: {
            self.addTodoBottomConstraint.constant = 0
            self.addTodoView.alpha = 0
            self.view.layoutIfNeeded()
        }) { (_) in
            self.addTodoView.todoTextView.resignFirstResponder()
            self.addTodoView.isHidden = true
        }
        
    }
    
    
}

// MARK: - Handle View Updates
extension TodosDetailViewController {
    
    enum TodoState {
        case present
        case keyboardHidden
        case discard
        case schedule
    }
    
    enum KeyboardState{
        case hidden
        case presented
    }
    
}





