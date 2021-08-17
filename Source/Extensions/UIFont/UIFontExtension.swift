//
//  UIFontExtension.swift
//  Signary
//
//  Created by Ameya Bhagat on 22/07/21.
//

import UIKit

typealias Font = UIFont
typealias FontMetrics = UIFontMetrics
typealias descriptorAttribute = FontDescriptor.AttributeName

enum UIFontExtError: Error {
    case fontNotFound
}
extension Font {
        
    class func preferredCustom(fontFamily family: String, textStyle style: TextStyle) -> Font? {

        var scaledFont: Font?
        //GET THE SIZE OF THE FONT FOR THE GIVEN TEXT STYLE
        let systemFontDescriptor = FontDescriptor.preferredDescriptor(textStyle: style, fontFamily: family)
        //CREATE ATTRIBUTES WITH SPECIFYING FONT FAMILY AND FONT SIZE
        let fontAttributes: [descriptorAttribute: Any] = [
            descriptorAttribute.family: family,
            descriptorAttribute.size: systemFontDescriptor.pointSize
        ]
        //CREATE A NEW FONT DESCRIPTOR WITH FONT ATTRIBUTES CREATED ABOVE
        let customFontDescriptor = FontDescriptor.init(fontAttributes: fontAttributes)
        //CREATE A FONT WITH NEW FONT DESCRIPTOR, SET SIZE ZERO, AS THE SIZE IS PASSED IN THE FONT ATTRIBUTES
        let customFont = Font(descriptor: customFontDescriptor, size: 0)
        //CREATE AN INSTANCE OF FONT METRICS WITH THE CURRENT TEXTSTYLE
        let metrics = FontMetrics(forTextStyle: style)
        //RETURN A DYNAMICALLY SCALED VERSION OF THE CUSTOM FONT
        scaledFont = metrics.scaledFont(for: customFont)
        
        return scaledFont
    }
}
