//
//  CustomFontController.swift
//  Signary
//
//  Created by Ameya Bhagat on 02/08/21.
//

import UIKit

class CustomFontController {
    //MARK:- PROPERTIES
    private let defaults: UserDefaults
    private(set) lazy var currentFont = UIFont()
    private let defaultsKey = "customFont"
    
    //MARK:- INIT
    init(defaults:UserDefaults = .standard) {
        self.defaults = defaults
    }
    
    func changeFont(to font: UIFont) {
        currentFont = font
        defaults.setValue(font.fontName, forKey: defaultsKey)
    }
    
    private func loadFont() -> UIFont {
        let rawValue = defaults.string(forKey: defaultsKey)
        return UIFont(name: rawValue!, size: 16)!
    }
    
    func switchCustomFont(_ fontIdentifier:CustomFonts) {
        
    }
}
