//
//  HapticFeedbackManager.swift
//  todo
//
//  Created by Alejandro Mendoza on 19/02/20.
//  Copyright © 2020 Alejandro Mendoza. All rights reserved.
//

import UIKit

class HapticFeedbackManager {
    static let sharedInstance = HapticFeedbackManager()
    
    func excecuteSelectionFeedback(){
        let feelFeedBackGenerator = UISelectionFeedbackGenerator()
        feelFeedBackGenerator.selectionChanged()
    }
    
    func excecuteImpactFeedback(intensity style: UIImpactFeedbackGenerator.FeedbackStyle){
        let impactFeedBackGenerator = UIImpactFeedbackGenerator(style: style)
        impactFeedBackGenerator.impactOccurred()
    }
    
    func excecuteNotificationFeedBack(notification: UINotificationFeedbackGenerator.FeedbackType){
        let notificationGenerator = UINotificationFeedbackGenerator()
        notificationGenerator.notificationOccurred(notification)
    }
    
}
