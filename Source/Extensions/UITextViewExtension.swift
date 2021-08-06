//
//  UITextViewExtension.swift
//  Signary
//
//  Created by Ameya Bhagat on 15/06/21.
//

import UIKit

public extension UITextView {
    /// Call this method to highlight the first line in the textView
    /// - Parameter font: If you have custom font, pass it here as UIFont. This method uses 'largeTitle' text style of system font by default.
    func highlightFirstLineInTextView(font: UIFont = UIFont.preferredFont(forTextStyle: .largeTitle)) {
        //TODO:- ADD COLOUR PARAMETER HERE AND PASS IT TO 'ADD ATTRIBUTE METHOD AT THE END
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
