//
//  UIFontExtension.swift
//  Signary
//
//  Created by Ameya Bhagat on 20/07/21.
//

import UIKit

enum CustomFontStyle: String {
    case Regular, Bold, Thin, Extralight, Light, Medium, Semibold, Extrabold, Black
}

struct CustomFontCreator {
    
    func createCustomFontSring(fontFamiliy: String, fontStyle: CustomFontStyle, italic: Bool = false) -> String {
        
        if !italic {
            switch fontStyle {
            case .Regular, .Bold, .Thin, .Extralight, .Light, .Medium, .Semibold, .Extrabold, .Black:
                return "\(fontFamiliy)-\(fontStyle.rawValue)"
            }
        } else {
            switch fontStyle {
            case .Regular, .Bold, .Thin, .Extralight, .Light, .Medium, .Semibold, .Extrabold, .Black:
                return "\(fontFamiliy)-\(fontStyle.rawValue)Italic"
            }
        }
    }
    
    func createCustomFontDictionary(fontFamiliy: String, italic: Bool = false) -> [UIFont.TextStyle: UIFont?] {
        var customFontRegular = String()
        var customFontBold = String()
        
        if !italic {
            customFontRegular = createCustomFontSring(fontFamiliy: fontFamiliy, fontStyle: .Regular)
            customFontBold = createCustomFontSring(fontFamiliy: fontFamiliy, fontStyle: .Bold, italic: true)
        }
        let customFonts: [UIFont.TextStyle: UIFont?] = [
            .largeTitle: UIFont(name: customFontRegular, size: 34),
            .title1: UIFont(name: customFontRegular, size: 28),
            .title2: UIFont(name: customFontRegular, size: 22),
            .title3: UIFont(name: customFontRegular, size: 20),
            .headline: UIFont(name: customFontBold, size: 17),
            .body: UIFont(name: customFontRegular, size: 17),
            .callout: UIFont(name: customFontRegular, size: 16),
            .subheadline: UIFont(name: customFontRegular, size: 15),
            .footnote: UIFont(name: customFontRegular, size: 13),
            .caption1: UIFont(name: customFontRegular, size: 12),
            .caption2: UIFont(name: customFontRegular, size: 11)
        ]
        
        return customFonts
    }
}
