//
//  FloatingButton.swift
//  todo
//
//  Created by Alejandro Mendoza on 09/12/19.
//  Copyright © 2019 Alejandro Mendoza. All rights reserved.
//

import UIKit

@IBDesignable
class FloatingButton: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var iconButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        customInit()
    }
    
    
    //MARK: Private Functions
    
    private func customInit(){
        
        let bundle = Bundle(for: FloatingButton.self)
        bundle.loadNibNamed(String(describing: FloatingButton.self), owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    

}
