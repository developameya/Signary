//
//  UIFontExtension.swift
//  Signary
//
//  Created by Ameya Bhagat on 22/07/21.
//

import UIKit

enum CustomFontCreatorError: Error {
    case fontNotFound, fontFamilyDoesNotExist
}
extension UIFont {
    
    class func customFont(fontFamliy family: String, forTextStyle style: UIFont.TextStyle) throws -> UIFont {
        let creator = CustomFontCreator()
        let customFontDict = creator.createCustomFontDictionary(fontFamiliy: family)
        
        guard let safeCustomFont = customFontDict[style] else {
            throw CustomFontCreatorError.fontNotFound
        }
        
        let metrics = UIFontMetrics(forTextStyle: style)
        guard let safeFont = safeCustomFont else {
            throw CustomFontCreatorError.fontFamilyDoesNotExist
        }
        return metrics.scaledFont(for: safeFont)
    }
}
