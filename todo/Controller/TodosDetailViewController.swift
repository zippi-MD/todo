//
//  TodosDetailViewController.swift
//  todo
//
//  Created by Alejandro Mendoza on 07/01/20.
//  Copyright © 2020 Alejandro Mendoza. All rights reserved.
//

import UIKit

class TodosDetailViewController: UIViewController {

    
    @IBOutlet weak var toolbarView: Toolbar!
    @IBOutlet weak var toolbarBottomConstraint: NSLayoutConstraint!
    
    let keyboardHandler = KeyboardEvents()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        keyboardHandler.registerForKeyboardEvents()
        keyboardHandler.delegate = self
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        keyboardHandler.unregisterFromKeyboardEvents()
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
        
    }
    
    func keyboardDidHide(_ notification: Notification) {
        
    }
    
    func keyboardWillChangeFrame(_ notification: Notification) {
        
    }
    
    func keyboardDidChangeFrame(_ notification: Notification) {
        
    }
    
    
}
