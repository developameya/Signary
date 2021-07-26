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
    
    func createCustomFontDictionary(of fontFamiliy: String, italic: Bool = false) throws -> [UIFont.TextStyle: UIFont] {
        var customFontRegular = String()
        var customFontBold = String()
        
        if !italic {
            customFontRegular = createCustomFontSring(fontFamiliy: fontFamiliy, fontStyle: .Regular)
            customFontBold = createCustomFontSring(fontFamiliy: fontFamiliy, fontStyle: .Bold)
        } else {
            customFontRegular = createCustomFontSring(fontFamiliy: fontFamiliy, fontStyle: .Regular, italic: true)
            customFontBold = createCustomFontSring(fontFamiliy: fontFamiliy, fontStyle: .Bold, italic: true)
        }
        
        guard let largeTitleFont = UIFont(name: customFontRegular, size: 34),
              let titleOneFont = UIFont(name: customFontRegular, size: 28),
              let titleTwoFont = UIFont(name: customFontRegular, size: 22),
              let titleThreeFont = UIFont(name: customFontRegular, size: 20),
              let headlineFont = UIFont(name: customFontBold, size: 17),
              let bodyFont = UIFont(name: customFontRegular, size: 17),
              let calloutFont = UIFont(name: customFontRegular, size: 16),
              let subheadlineFont =  UIFont(name: customFontRegular, size: 15),
              let footNoteFont = UIFont(name: customFontRegular, size: 13),
              let captionOneFont = UIFont(name: customFontRegular, size: 12),
              let captionTwoFont =  UIFont(name: customFontRegular, size: 11) else {
            throw CustomFontCreatorError.fontFamilyDoesNotExist
        }
        
        let customFonts: [UIFont.TextStyle: UIFont] = [
            .largeTitle: largeTitleFont,
            .title1: titleOneFont,
            .title2: titleTwoFont,
            .title3: titleThreeFont,
            .headline: headlineFont,
            .body: bodyFont,
            .callout: calloutFont,
            .subheadline: subheadlineFont,
            .footnote: footNoteFont,
            .caption1: captionOneFont,
            .caption2: captionTwoFont
        ]
        
        return customFonts
    }
}
