//
//  HeaderView.swift
//  todo
//
//  Created by Alejandro Mendoza on 14/01/20.
//  Copyright © 2020 Alejandro Mendoza. All rights reserved.
//

import UIKit

protocol HeaderViewDelegate: class {
    func starActionSelected()
    func shareActionSelected()
    func addActionSelected()
}

class HeaderView: UIView {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var starActionImageView: UIImageView!
    @IBOutlet weak var shareActionImageView: UIImageView!
    @IBOutlet weak var addActionImageView: UIImageView!
    
    weak var delegate: HeaderViewDelegate?
    
    var headerTagColor: UIColor = UIColor.systemPink
    var headerTag: String = "" {
        willSet {
            if var location = getLocationOfTagFrom(newValue, beginningWith: "#") {
                location.length = location.length + 1
                let attributed = getHighlightedTextFor(newValue, withLocation: location, color: headerTagColor)
                tagLabel.attributedText = attributed
            }
        }
    }
    
    var isStared: Bool = false {
        willSet {
            if newValue {
                starActionImageView.image = UIImage(systemName: "star.fill")
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
        
        addGestureRecognizerToActions()
    }
    
    func addGestureRecognizerToActions(){
        let starTap = UITapGestureRecognizer(target: self, action: #selector(starActionWasSelected))
        starActionImageView.addGestureRecognizer(starTap)
        
        let shareTap = UITapGestureRecognizer(target: self, action: #selector(shareActionWasSelected))
        shareActionImageView.addGestureRecognizer(shareTap)
        
        let addTap = UITapGestureRecognizer(target: self, action: #selector(addActionWasSelected))
        addActionImageView.addGestureRecognizer(addTap)
        
    }
    
    
    @objc func starActionWasSelected(){
        delegate?.starActionSelected()
    }
    
    @objc func shareActionWasSelected(){
        delegate?.shareActionSelected()
    }
    
    @objc func addActionWasSelected(){
        delegate?.addActionSelected()
    }

}
