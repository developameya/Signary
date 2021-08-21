//
//  UIFontExtension.swift
//  Signary
//
//  Created by Ameya Bhagat on 22/07/21.
//

import UIKit

public typealias Font = UIFont
typealias FontMetrics = UIFontMetrics
typealias descriptorAttribute = FontDescriptor.AttributeName

enum UIFontExtError: Error {
    case fontNotFound
}
public extension Font {
    
    
    var traits: FontDescriptor.SymbolicTraits {
        return fontDescriptor.symbolicTraits
    }
        
    func contains(trait: FontDescriptor.SymbolicTraits) -> Bool {
        return traits.contains(trait)
    }
    
    func remove(trait: FontDescriptor.SymbolicTraits) -> UIFont {
        var traits = self.traits
        traits.subtract(trait)
        guard let updatedFontDescriptor = fontDescriptor.withSymbolicTraits(traits) else {return self}
        
        return Font(descriptor: updatedFontDescriptor, size: 0)
    }
    
    func add(trait: FontDescriptor.SymbolicTraits) -> UIFont {
        var traits = self.traits
        traits.formUnion(trait)
        guard let updatedFontDescriptor = fontDescriptor.withSymbolicTraits(traits) else {return self}
        
        return Font(descriptor: updatedFontDescriptor, size: 0)
    }
    
    func toggle(trait: FontDescriptor.SymbolicTraits) -> UIFont {
        var updatedFont: UIFont
        
        if self.contains(trait: trait) {
            updatedFont = remove(trait: trait)
        } else {
            updatedFont = add(trait: trait)
        }
        
        return updatedFont
    }
    
    /// Use this method to get a custom font which was bundled with the app.
    /// - Parameter fontFamily: Pass the family name of the font.
    /// - Returns: Returns an optional `UIFont` matching the family name and of size `0.0`.
    class func from(fontFamily: String) -> Font? {
        
        let descriptor = FontDescriptor(name: fontFamily, size: 0.0)
        
        return Font(descriptor: descriptor, size: 0.0)
    }
    
    class func dynamicCustom(font: Font, textStyle style: TextStyle) -> Font? {

        var customFont: Font?
        //CREATE A CUSTOM FONT DESCRIPTOR WITH THE CURRENT SYSTEM FONT SIZE
        let descriptor = FontDescriptor.CustomFontDescriptor(font: font, textStyle: style)
        let newFont = Font(descriptor: descriptor, size: 0)
        
        customFont = self.dynamicFont(font: newFont)
        
        return customFont
    }
    
    class func dynamicFont(font: Font)-> Font? {
        var scaledFont: Font?
        //CREATE AN INSTANCE OF FONT METRICS WITH THE CURRENT TEXTSTYLE
        let metrics = FontMetrics.default
        //RETURN A DYNAMICALLY SCALED VERSION OF THE CUSTOM FONT
        scaledFont = metrics.scaledFont(for: font)
        
        return scaledFont
    }
}
