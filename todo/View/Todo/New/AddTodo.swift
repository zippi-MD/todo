//
//  AddTodo.swift
//  todo
//
//  Created by Alejandro Mendoza on 07/01/20.
//  Copyright © 2020 Alejandro Mendoza. All rights reserved.
//

import UIKit

protocol AddTodoDelegate: class {
    func addTodoDidBecameFirstResponder()
}

@IBDesignable
class AddTodo: UIView {

    @IBOutlet private var containerView: AddTodo!
    @IBOutlet private weak var todoBackgroundView: UIView!
    
    @IBOutlet private weak var todoTextView: UITextView!
    @IBOutlet private weak var todoDateLabel: UILabel!
    
    let todoManager = TodoManager.sharedInstance
    weak var delegate: AddTodoDelegate?
    var todoTagName: String?
    var todoDescription: String {
        get {
            todoTextView.text
        }
    }
    var todoScheduleDate: Date? {
        willSet {
            if let date = newValue {
                todoDateLabel.text = getLocalShortDateFor(date)
            }
            else {
                todoDateLabel.text = ""
            }
        }
    }
    private var todoTagBackgroundColor = TagBackgroundColors.allCases.randomElement() ?? TagBackgroundColors.TagPink1
    private var temporalTodoTagBackgroundColor: TagBackgroundColors?
    
    var tagColor: TagBackgroundColors {
        get {
            if let color = temporalTodoTagBackgroundColor {
                return color
            }
            else {
                return todoTagBackgroundColor
            }
        }
    }
    
    override init(frame: CGRect) {
       super.init(frame: frame)
       customInit()
    }
       
    required init?(coder: NSCoder) {
       super.init(coder: coder)
       customInit()
    }
    
    func resignAsFirstResponder() {
        self.todoTextView.resignFirstResponder()
    }
    
    func setAsFirstResponder(){
        self.todoTextView.becomeFirstResponder()
    }
    
    func resetValues() {
        self.todoTextView.text = ""
        self.todoTextView.attributedText = NSAttributedString(string: "")
        self.todoTagBackgroundColor = TagBackgroundColors.allCases.randomElement() ?? TagBackgroundColors.TagPink1
    }
    
    func setInitialTagValueWith(_ tag: String) {
        self.todoTextView.text = tag
        UIApplication.shared.sendAction(#selector(textViewDidChange(_:)), to: self, from: todoTextView, for: nil)
    }
    
    private func customInit(){
        let bundle = Bundle(for: AddTodo.self)
        bundle.loadNibNamed(String(describing: AddTodo.self), owner: self, options: nil)
        addSubview(containerView)
        containerView.frame = bounds
        containerView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        alignTextVerticallyInContainer()
        todoTextView.delegate = self
        setupUI()
    }
    
    private func setupUI(){
        todoBackgroundView.layer.cornerRadius = Constants.TodoCornerRadius
        todoTextView.layer.cornerRadius = Constants.TodoCornerRadius
        containerView.layer.cornerRadius = Constants.TodoCornerRadius * 2
    }
    
    private func alignTextVerticallyInContainer() {
        var topCorrect = (todoTextView.bounds.size.height - todoTextView.contentSize.height * todoTextView.zoomScale) / 2
        topCorrect = topCorrect < 0.0 ? 0.0 : topCorrect;
        todoTextView.contentInset.top = topCorrect
    }
    
}

extension AddTodo: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        
        let text = textView.text ?? ""
        let cursorLocation = textView.selectedRange.location
        
        if  let location = getLocationOfTagFrom(text, beginningWith: "#"){
            
            var color = getColorFrom(todoTagBackgroundColor)
            var attributed = getHighlightedTextFor(text, withLocation: location, color: color)
            todoTagName = getTagFrom(attributed, tagLocation: location)
            
            if  let tagBackgroungColor = todoManager.getColorForTag(todoTagName ?? ""){
                temporalTodoTagBackgroundColor = tagBackgroungColor
                color = getColorFrom(tagBackgroungColor)
                attributed = getHighlightedTextFor(text, withLocation: location, color: color)
            }
            else {
                temporalTodoTagBackgroundColor = nil
            }
            
            textView.attributedText = attributed
        }
        else {
            todoTagName = nil
        }
        
        textView.selectedRange = NSRange(location: cursorLocation, length: 0)
        textView.textAlignment = .center
        alignTextVerticallyInContainer()
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        alignTextVerticallyInContainer()
        delegate?.addTodoDidBecameFirstResponder()
    }
}
