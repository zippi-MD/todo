//
//  HeaderView.swift
//  todo
//
//  Created by Alejandro Mendoza on 14/01/20.
//  Copyright © 2020 Alejandro Mendoza. All rights reserved.
//

import UIKit

protocol HeaderViewDelegate: class {
    func shareActionSelected()
    func addActionSelected()
}

class HeaderView: UIView {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var headerBackgroundView: UIView! {
        didSet {
            headerBackgroundView.layer.cornerRadius = Constants.TodoCornerRadius
        }
    }
    
    weak var delegate: HeaderViewDelegate?
    
    var headerTagColor: UIColor = UIColor.systemPink {
        willSet {
            if  let location = getLocationOfTagFrom(headerTag, beginningWith: "#") {
                let attributed = getHighlightedTextFor(headerTag, withLocation: location, color: newValue, wide: true)
                tagLabel.attributedText = attributed
            }
        }
    }
    var headerTag: String = "" {
        willSet {
            if let location = getLocationOfTagFrom(newValue, beginningWith: "#") {
                let attributed = getHighlightedTextFor(newValue, withLocation: location, color: headerTagColor, wide: true)
                tagLabel.attributedText = attributed
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
    
    func customInit(){
        let bundle = Bundle(for: HeaderView.self)
        bundle.loadNibNamed(String(describing: HeaderView.self), owner: self, options: nil)
        addSubview(containerView)
        containerView.frame = bounds
        containerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
    }
    
    @IBAction func headerShareActionWasTapped(_ sender: UIButton) {
        delegate?.shareActionSelected()
    }
    
    @IBAction func headerAddActionWasTapped(_ sender: UIButton) {
        delegate?.addActionSelected()
    }

}
