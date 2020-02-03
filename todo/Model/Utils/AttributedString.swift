//
//  AttributedString.swift
//  todo
//
//  Created by Alejandro Mendoza on 10/01/20.
//  Copyright © 2020 Alejandro Mendoza. All rights reserved.
//

import UIKit

func getLocationOfTagFrom(_ string: String, beginningWith tagIdentifier: String) -> NSRange? {
    
    let originalString = NSString(string: string)
    let startRange = originalString.range(of: tagIdentifier, options: .caseInsensitive)
    
    if startRange.length > 0 {
        let startLocation: Int = startRange.location
        let tagSringLength: Int
        
        let subStringFromTagIdentifier = NSString(string: originalString.substring(from: startRange.location))
        let set = NSCharacterSet.whitespacesAndNewlines
        let endRange: NSRange = subStringFromTagIdentifier.rangeOfCharacter(from: set)
        
        if endRange.length > 0 {
            tagSringLength = endRange.location
        }
        else {
            tagSringLength =  subStringFromTagIdentifier.length
        }
        
        return NSRange(location: startLocation, length: tagSringLength)
    }
    else {
        return nil
    }
}


func getHighlightedTextFor(_ string: String, withLocation location: NSRange, color: UIColor, wide: Bool = false) -> NSMutableAttributedString {
    
    let attributed = NSMutableAttributedString(string: string)
    
    if wide {
        let textToHighlight = NSMutableAttributedString(string: attributed.attributedSubstring(from: location).string)
        textToHighlight.insert(NSAttributedString(string: " "), at: 0)
        textToHighlight.insert(NSAttributedString(string: " "), at: textToHighlight.length)
    
        let rangeToHighlight = NSRange(location: 0, length: textToHighlight.length)
    
        attributed.deleteCharacters(in: location)
        
        textToHighlight.addAttributes([.backgroundColor: color], range: rangeToHighlight)
        textToHighlight.addAttributes([.foregroundColor: UIColor.white], range: rangeToHighlight)
        
        attributed.insert(textToHighlight, at: location.lowerBound)
        
        return attributed
    }
    
    attributed.addAttributes([.backgroundColor: color], range: location)
    attributed.addAttributes([.foregroundColor: UIColor.white], range: location)
    
    return attributed
    
}

func getTagFrom(_ string: NSMutableAttributedString, tagLocation location: NSRange) -> String {
    let tag = string.attributedSubstring(from: location)
    return tag.string
}
