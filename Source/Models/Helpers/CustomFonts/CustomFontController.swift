//
//  CustomFontController.swift
//  Signary
//
//  Created by Ameya Bhagat on 02/08/21.
//

import UIKit

enum CustomFontControllerError: Error {
    case headerAttributesAreNil, bodyAttributesAreNil
}

enum defaultsKey : String {
    case headerAttributes, bodyAttributes, initialise
}

class CustomFontController {
    //MARK:- PROPERTIES
    private let defaults: UserDefaults
    private var defaultsKey: defaultsKey = .initialise
    
    //MARK:- INIT
    init(defaults:UserDefaults = .standard) {
        self.defaults = defaults
    }
    
    func saveFontAttributes(header headerFontAttributes: [NSAttributedString.Key : Any]? = nil, body bodyFontAttributes: [NSAttributedString.Key : Any]? = nil) throws {
        //FIXME:- METHOD WILL FAIL "reason: 'Attempt to insert non-property list object"
        if let safeHeaderAttributes = headerFontAttributes {
            defaultsKey = .headerAttributes
            defaults.setValue(safeHeaderAttributes, forKey: defaultsKey.rawValue)
        } else {
            throw CustomFontControllerError.bodyAttributesAreNil
        }
        
        if let safeBodyAttributes = bodyFontAttributes {
            defaultsKey = .bodyAttributes
            defaults.setValue(safeBodyAttributes, forKey: defaultsKey.rawValue)
        } else {
            throw CustomFontControllerError.headerAttributesAreNil
        }
    }
    
//        private func loadFont() -> UIFont {
//            let rawValue = defaults.string(forKey: defaultsKey)
//            return UIFont(name: rawValue!, size: 16)!
//}

}
