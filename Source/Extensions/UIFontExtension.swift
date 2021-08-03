//
//  UIFontExtension.swift
//  Signary
//
//  Created by Ameya Bhagat on 22/07/21.
//

import UIKit

enum CustomFontExtensionError: Error {
    case fontNotFound
}
extension UIFont {
    
    class func customFont(fontFamliy family: CustomFonts.RawValue, forTextStyle style: UIFont.TextStyle) throws -> UIFont {
        
        let creator = CustomFontCreator()
        
        let customFontDict = try creator.createCustomFontDictionary(of: family)

        guard let customFont = customFontDict[style] else { throw CustomFontExtensionError.fontNotFound }
        
        let metrics = UIFontMetrics(forTextStyle: style)

        return metrics.scaledFont(for: customFont)
    }
}
