//
//  NSMutableAttributedStringExtension.swift
//  Signary
//
//  Created by Ameya Bhagat on 19/08/21.
//

import Foundation

extension NSMutableAttributedString {
    
    func updateFontAttribute(with font: Font) {
        beginEditing()
        
        self.enumerateAttribute(.font, in: NSRange(location: 0, length: self.length)) { value, range, stop in
            
            if let currentFont = value as? Font,
               let newFontDescriptor = font.fontDescriptor
                .withSymbolicTraits(currentFont.fontDescriptor.symbolicTraits)?
                .withSize(currentFont.fontDescriptor.pointSize) {
                
                let newFont = Font(descriptor: newFontDescriptor, size: 0)
                
                let scaledFont = Font.dynamicFont(font: newFont)
                
                removeAttribute(.font, range: range)
                
                addAttribute(.font, value: scaledFont!, range: range)
            }
            
            endEditing()
        }
    }
}
