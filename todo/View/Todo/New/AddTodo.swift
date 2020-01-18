//
//  AddTodo.swift
//  todo
//
//  Created by Alejandro Mendoza on 07/01/20.
//  Copyright © 2020 Alejandro Mendoza. All rights reserved.
//

import UIKit
@IBDesignable
class AddTodo: UIView {

    @IBOutlet var containerView: AddTodo!
    @IBOutlet weak var todoBackgroundView: UIView!
    
    @IBOutlet weak var todoTextView: UITextView!
    
    var todoTag: String?
    
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
        bundle.loadNibNamed(String(describing: AddTodo.self), owner: self, options: nil)
        addSubview(containerView)
        containerView.frame = bounds
        containerView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        alignTextVerticallyInContainer()
        todoTextView.delegate = self
        setupUI()
    }
    
    func setupUI(){
        todoBackgroundView.layer.cornerRadius = Constants.TodoCornerRadius
        todoTextView.layer.cornerRadius = Constants.TodoCornerRadius
    }
    
    func alignTextVerticallyInContainer() {
        var topCorrect = (todoTextView.bounds.size.height - todoTextView.contentSize.height * todoTextView.zoomScale) / 2
        topCorrect = topCorrect < 0.0 ? 0.0 : topCorrect;
        todoTextView.contentInset.top = topCorrect
    }
    
}

extension AddTodo: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        
        let text = textView.text ?? ""
        let cursorLocation = textView.selectedRange.location
        
        if let location = getLocationOfTagFrom(text, beginningWith: "#") {
            let attributed = getHighlightedTextFor(text, withLocation: location, color: UIColor.systemPink)
            todoTag = getTagFrom(attributed, tagLocation: location)
            textView.attributedText = attributed
        }
        else {
            todoTag = nil
        }
        
        textView.selectedRange = NSRange(location: cursorLocation, length: 0)
        textView.textAlignment = .center
        alignTextVerticallyInContainer()
        
    }
}
