//
//  UITextViewExtension.swift
//  Signary
//
//  Created by Ameya Bhagat on 15/06/21.
//

import UIKit

public extension UITextView {
    
    func highlightFirstLineInTextView(font: UIFont = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.largeTitle)) {
        
        let textAsNSString = text as NSString
        let lineBreakRange = textAsNSString.range(of: "\n")
        
        let newAttributedText = NSMutableAttributedString(attributedString: attributedText)
        let boldRange: NSRange
        
        if lineBreakRange.location < textAsNSString.length {
            boldRange = NSRange(location: 0, length: lineBreakRange.location)
        } else {
            boldRange = NSRange(location: 0, length: textAsNSString.length)
        }
        
        newAttributedText.addAttribute(NSAttributedString.Key.font, value: font, range: boldRange)
        attributedText = newAttributedText
    }
}
