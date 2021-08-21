//
//  NSMutableAttributedStringExtension.swift
//  Signary
//
//  Created by Ameya Bhagat on 19/08/21.
//

import Foundation

extension NSMutableAttributedString {
    
    func updateFontAttributeWith(font fontToUpdate: Font) {
        beginEditing()
        
        self.enumerateAttribute(.font, in: NSRange(location: 0, length: self.length)) { value, range, stop in
            
            if let currentFont = value as? Font,
               let newFontDescriptor = currentFont.fontDescriptor
                .withFamily(fontToUpdate.familyName)
                .withSymbolicTraits(currentFont.fontDescriptor.symbolicTraits) {
                
                let newFont = Font(descriptor: newFontDescriptor, size: 0)
                
                let scaledFont = Font.dynamicFont(font: newFont)
                
                removeAttribute(.font, range: range)
                
                addAttribute(.font, value: scaledFont!, range: range)
            }
            
            endEditing()
        }
    }
}
