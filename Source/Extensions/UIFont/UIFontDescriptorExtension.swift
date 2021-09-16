//
//  UIFontDescriptorExtension.swift
//  Signary
//
//  Created by Ameya Bhagat on 16/08/21.
//

import UIKit

public typealias FontDescriptor = UIFontDescriptor
typealias TextStyle = UIFont.TextStyle
typealias ContentSizeCategory = UIContentSizeCategory

extension FontDescriptor {
    //SET CUSTOM FONT SIZE FOR EVERY DYNAMIC FONT SIZE PROIVDED BY THE SYSTEM
    static let fontSizeTable: [TextStyle: [ContentSizeCategory: CGFloat]] = [
        .headline: [
            .accessibilityExtraExtraExtraLarge: 23,
            .accessibilityExtraExtraLarge: 23,
            .accessibilityExtraLarge: 23,
            .accessibilityLarge: 23,
            .accessibilityMedium: 23,
            .extraExtraExtraLarge: 23,
            .extraExtraLarge: 21,
            .extraLarge: 19,
            .large: 17,
            .medium: 16,
            .small: 15,
            .extraSmall: 14
        ],
        .subheadline: [
            .accessibilityExtraExtraExtraLarge: 21,
            .accessibilityExtraExtraLarge: 21,
            .accessibilityExtraLarge: 21,
            .accessibilityLarge: 21,
            .accessibilityMedium: 21,
            .extraExtraExtraLarge: 21,
            .extraExtraLarge: 19,
            .extraLarge: 17,
            .large: 15,
            .medium: 14,
            .small: 13,
            .extraSmall: 12
        ],
        .body: [
            .accessibilityExtraExtraExtraLarge: 53,
            .accessibilityExtraExtraLarge: 47,
            .accessibilityExtraLarge: 40,
            .accessibilityLarge: 33,
            .accessibilityMedium: 28,
            .extraExtraExtraLarge: 23,
            .extraExtraLarge: 21,
            .extraLarge: 19,
            .large: 17,
            .medium: 16,
            .small: 15,
            .extraSmall: 14
        ],
        .caption1: [
            .accessibilityExtraExtraExtraLarge: 18,
            .accessibilityExtraExtraLarge: 18,
            .accessibilityExtraLarge: 18,
            .accessibilityLarge: 18,
            .accessibilityMedium: 18,
            .extraExtraExtraLarge: 18,
            .extraExtraLarge: 16,
            .extraLarge: 14,
            .large: 12,
            .medium: 11,
            .small: 11,
            .extraSmall: 11
        ],
        .caption2: [
            .accessibilityExtraExtraExtraLarge: 17,
            .accessibilityExtraExtraLarge: 17,
            .accessibilityExtraLarge: 17,
            .accessibilityLarge: 17,
            .accessibilityMedium: 17,
            .extraExtraExtraLarge: 17,
            .extraExtraLarge: 15,
            .extraLarge: 13,
            .large: 11,
            .medium: 11,
            .small: 11,
            .extraSmall: 11
        ],
        .footnote: [
            .accessibilityExtraExtraExtraLarge: 19,
            .accessibilityExtraExtraLarge: 19,
            .accessibilityExtraLarge: 19,
            .accessibilityLarge: 19,
            .accessibilityMedium: 19,
            .extraExtraExtraLarge: 19,
            .extraExtraLarge: 17,
            .extraLarge: 15,
            .large: 13,
            .medium: 12,
            .small: 12,
            .extraSmall: 12
        ],
        .largeTitle: [
            .accessibilityExtraExtraExtraLarge: 60,
            .accessibilityExtraExtraLarge: 56,
            .accessibilityExtraLarge: 52,
            .accessibilityLarge: 48,
            .accessibilityMedium: 44,
            .extraExtraExtraLarge: 40,
            .extraExtraLarge: 38,
            .extraLarge: 36,
            .large: 34,
            .medium: 33,
            .small: 32,
            .extraSmall: 31
        ],
        .title1: [
            .accessibilityExtraExtraExtraLarge: 58,
            .accessibilityExtraExtraLarge: 53,
            .accessibilityExtraLarge: 48,
            .accessibilityLarge: 43,
            .accessibilityMedium: 38,
            .extraExtraExtraLarge: 34,
            .extraExtraLarge: 32,
            .extraLarge: 30,
            .large: 28,
            .medium: 27,
            .small: 26,
            .extraSmall: 25
        ],
        .title2: [
            .accessibilityExtraExtraExtraLarge: 56,
            .accessibilityExtraExtraLarge: 50,
            .accessibilityExtraLarge: 44,
            .accessibilityLarge: 39,
            .accessibilityMedium: 34,
            .extraExtraExtraLarge: 28,
            .extraExtraLarge: 26,
            .extraLarge: 24,
            .large: 22,
            .medium: 21,
            .small: 20,
            .extraSmall: 19
        ],
        .title3: [
            .accessibilityExtraExtraExtraLarge: 55,
            .accessibilityExtraExtraLarge: 49,
            .accessibilityExtraLarge: 43,
            .accessibilityLarge: 37,
            .accessibilityMedium: 31,
            .extraExtraExtraLarge: 26,
            .extraExtraLarge: 24,
            .extraLarge: 22,
            .large: 20,
            .medium: 19,
            .small: 18,
            .extraSmall: 17
        ]
    ]
    
    final class func preferredDescriptor(font: Font, textStyle: TextStyle) -> FontDescriptor {
        //GET THE CURRENT FONT SIZE SET BY THE SYSTEM
        let contentSize = UIApplication.shared.preferredContentSizeCategory
        //GET THE ARRAY VALUE FOR THE SELECTED TEXTSTYLE
        let style = fontSizeTable[textStyle]!
        //RETURN A FONT DESCRIPTOR WITH FONT SIZE MATCHING THE CURRENT DYNAMIC SIZE PROVIDED BY THE SYSTEM
        return FontDescriptor(name: font.familyName, size: style[contentSize]!)
    }
    
    final class func CustomFontDescriptor(font: Font, textStyle style: TextStyle) -> FontDescriptor {
        //GET THE SIZE OF THE FONT FOR THE GIVEN TEXT STYLE
        let systemFontDescriptor = self.preferredDescriptor(font: font, textStyle: style)
        //GET THE FONT DESCRIPTOR OF THE CURRENT FONT
        let fontDescriptor = font.fontDescriptor
        //CREATE ATTRIBUTES WITH SPECIFIC FONT SIZE
        let fontAttributes: [descriptorAttribute: Any] = [
            descriptorAttribute.size: systemFontDescriptor.pointSize,
        ]
        //CREATE A NEW FONT DESCRIPTOR WITH FONT ATTRIBUTES CREATED ABOVE
        let returnedDescriptor = fontDescriptor.addingAttributes(fontAttributes)
        return returnedDescriptor
    }
}
