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
    
    class func customFont(fontFamliy family: Fonts, forTextStyle style: UIFont.TextStyle) -> UIFont? {
        
        var scaledFont: UIFont?
        
        do {
            let creator = FontCreator()
            
            let customFontDict = try creator.createCustomFontDictionary(of: family.rawValue)

            guard let customFont = customFontDict[style] else { fatalError() }
            
            let metrics = UIFontMetrics(forTextStyle: style)
            
            scaledFont = metrics.scaledFont(for: customFont)
            
        } catch FontCreatorError.invalidFontName {
            
            print("\(String(describing: self))\(#function) Error at line \(#line) | The font name is invalid.")
            
        } catch {
            
            print("\(String(describing: self))\(#function) Error at line \(#line) | Unexpected error: \(error).")
        }

        return scaledFont
    }
    
}
