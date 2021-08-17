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
    
    class func preferredCustom(fontFamily family: String, textStyle style: TextStyle) -> Font? {

        var scaledFont: Font?
        //GET THE SIZE OF THE FONT FOR THE GIVEN TEXT STYLE
        let systemFontDescriptor = FontDescriptor.preferredDescriptor(textStyle: style, fontFamily: family)
        //CREATE ATTRIBUTES WITH SPECIFYING FONT FAMILY AND FONT SIZE
        let fontAttributes: [descriptorAttribute: Any] = [
            descriptorAttribute.family: family,
            descriptorAttribute.size: systemFontDescriptor.pointSize,
            //TODO:- TEST
            descriptorAttribute.traits: [
                UIFontDescriptor.TraitKey.weight: UIFont.Weight.bold
            ]
        ]
        //CREATE A NEW FONT DESCRIPTOR WITH FONT ATTRIBUTES CREATED ABOVE
        let customFontDescriptor = FontDescriptor.init(fontAttributes: fontAttributes)
        //CREATE A FONT WITH NEW FONT DESCRIPTOR, SET SIZE ZERO, AS THE SIZE IS PASSED IN THE FONT ATTRIBUTES
        let customFont = Font(descriptor: customFontDescriptor, size: 0)
        //CREATE AN INSTANCE OF FONT METRICS WITH THE CURRENT TEXTSTYLE
        let metrics = FontMetrics(forTextStyle: style)
        //RETURN A DYNAMICALLY SCALED VERSION OF THE CUSTOM FONT
        scaledFont = metrics.scaledFont(for: customFont)
        
        if ((scaledFont?.fontDescriptor.symbolicTraits.contains(.traitBold)) != nil) {
            print("contains bold")
        } else {
            print("not bold")
        }
        
        return scaledFont
    }
}
