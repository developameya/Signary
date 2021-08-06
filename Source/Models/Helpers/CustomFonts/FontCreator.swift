//
//  UIFontExtension.swift
//  Signary
//
//  Created by Ameya Bhagat on 20/07/21.
//

import UIKit

enum FontCreatorError: Error {
    case invalidFontName
}


enum CustomFontStyle: String {
    case Regular, Bold, Thin, Extralight, Light, Medium, Semibold, Extrabold, Black
}

struct FontCreator{
    
    func createCustomFontString(fontFamiliy famliy: Fonts.RawValue, fontStyle style: CustomFontStyle, italic: Bool = false) -> String {
        
        if !italic {
            switch style {
            case .Regular, .Bold, .Thin, .Extralight, .Light, .Medium, .Semibold, .Extrabold, .Black:
                return "\(famliy)-\(style.rawValue)"
            }
        } else {
            switch style {
            case .Regular, .Bold, .Thin, .Extralight, .Light, .Medium, .Semibold, .Extrabold, .Black:
                return "\(famliy)-\(style.rawValue)Italic"
            }
        }
    }
    
    func createCustomFontDictionary(of fontFamiliy: Fonts.RawValue, italic: Bool = false) throws -> [UIFont.TextStyle: UIFont] {
        var customFontRegular = String()
        var customFontBold = String()
        
        if !italic {
            customFontRegular = createCustomFontString(fontFamiliy: fontFamiliy, fontStyle: .Regular)
            customFontBold = createCustomFontString(fontFamiliy: fontFamiliy, fontStyle: .Bold)
        } else {
            customFontRegular = createCustomFontString(fontFamiliy: fontFamiliy, fontStyle: .Regular, italic: true)
            customFontBold = createCustomFontString(fontFamiliy: fontFamiliy, fontStyle: .Bold, italic: true)
        }
        
        guard let largeTitleFont = UIFont(name: customFontRegular, size: 34),
              let titleOneFont = UIFont(name: customFontRegular, size: 28),
              let titleTwoFont = UIFont(name: customFontRegular, size: 22),
              let titleThreeFont = UIFont(name: customFontRegular, size: 20),
              let bodyFont = UIFont(name: customFontRegular, size: 17),
              let calloutFont = UIFont(name: customFontRegular, size: 16),
              let subheadlineFont =  UIFont(name: customFontRegular, size: 15),
              let footNoteFont = UIFont(name: customFontRegular, size: 13),
              let captionOneFont = UIFont(name: customFontRegular, size: 12),
              let captionTwoFont =  UIFont(name: customFontRegular, size: 11),
              let headlineFont = UIFont(name: customFontBold, size: 17)
        else {
            
           throw FontCreatorError.invalidFontName
            
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
