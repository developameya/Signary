//
//  UITextViewExtension.swift
//  Signary
//
//  Created by Ameya Bhagat on 15/06/21.
//

import UIKit

public extension UITextView {
    
    ///Selected Text in the TextView
    var selectedText: NSAttributedString {
        return attributedText.attributedSubstring(from: selectedRange)
    }
    
    /// Determines if the TextView is empty.
    var isEmpty: Bool {
        return attributedText.length == 0
    }
    
    /// Expsoses the `addAttributes` method of `textStorage` as a direct method of `UITextView`.
    /// Adds the given collection of attributes to the characters in the specified range.
    /// - Parameters:
    /// - attrs: A dictionary containing the attributes to add. Attribute keys can be supplied by another framework or can be custom ones you define. For information about the system-supplied attribute keys, see the Constants section in NSAttributedString.
    /// - Parameter range: The range of characters to which the specified attributes apply.
    func addAttributes(_ attrs: DynamicFontDictionary, range: NSRange) {
        textStorage.addAttributes(attrs, range: range)
    }
    
    func addAttribute(_ name: AttrStrKey, value: Any, at range: NSRange) {
        self.addAttributes([name: value], range: range)
    }
    
    /// Expsoses the `enumerateAttribute` method of `textStorage` as a direct method of `UITextView`. Executes the specified closure for each range of a particular attribute in the attributed string.
    ///
    /// If this method is called by an instance of NSMutableAttributedString, mutation (deletion, addition, or change) is allowed only if the mutation is within the range provided to the block. After a mutation, the enumeration continues with the range immediately following the processed range, adjusting for any change in length caused by the mutation. For example, if block is called with a range starting at location N, and the block deletes all the characters in the provided range, the next call will also pass N as the location of the range. */

    /// - Parameters:
    ///   - attrName: The name of the attribute to enumerate.
    ///   - enumerationRange: The range over which the attribute values are enumerated.
    ///   - opts: The options used by the enumeration. For possible values, see NSAttributedString.EnumerationOptions.
    ///   - block: A closure to apply to ranges of the specified attribute in the attributed string.
    ///     The closure takes three arguments:
    ///     * The value for the specified attribute.
    ///     * The range of the attribute value in the attributed string.
    ///     * A reference to a Boolean value, which you can set to true within the closure to stop further processing of the attributed string.
    func enumerateAttribute(_ attrName: AttrStrKey, in enumerationRange: NSRange, options opts: NSAttributedString.EnumerationOptions = [], using block: (Any?, NSRange, UnsafeMutablePointer<ObjCBool>)-> Void) {
        textStorage.enumerateAttribute(attrName, in: enumerationRange, options: opts, using: block)
    }
    
    /// Call this method to highlight the first line in the textView
    /// - Parameter font: If you have custom font, pass it here as UIFont. This method uses 'largeTitle' text style of system font by default.
    func highlightFirstLineInTextView(font: UIFont = UIFont.preferredFont(forTextStyle: .largeTitle)) {
        //TODO:- ADD COLOUR PARAMETER HERE AND PASS IT TO `ADD ATTRIBUTE METHOD` AT THE END
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
