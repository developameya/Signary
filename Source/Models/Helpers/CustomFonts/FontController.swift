//
//  CustomFontController.swift
//  Signary
//
//  Created by Ameya Bhagat on 02/08/21.
//

import UIKit

typealias AttrStrKey = NSAttributedString.Key
typealias FontFormattingDictionary = [ AttrStrKey : Any]

enum fontAttributes: String {
    case header, body
}

struct FontController {
    //MARK:- PROPERTIES
    private var defaults: UserDefaults

    //MARK:- INIT
    init(defaults: UserDefaults = .standard) {
        
        self.defaults = defaults
        
    }
    
    func getFontAttributes(forKey key: fontAttributes) -> FontFormattingDictionary? {
        
        let stringKey = key.rawValue
        
        return defaults.getFontFormattingDictionary(forKey: stringKey)
        
    }
    
    func setFontAttributes(forKey key: fontAttributes, fontFamily family: Fonts, forTextStyle style: UIFont.TextStyle, textColourName name: String = "editorTextColour") -> FontFormattingDictionary? {
        
        var returnedDictionary: FontFormattingDictionary?
        
        if family == .SystemFont {
            //IF FAMILY IS SET TO SYSTEM, RETURN NIL
            returnedDictionary = nil
            //SAVE PREFERENCE TO USER DEFAULTS
            defaults.setFontDefaults(forKey: key.rawValue, fontObject: returnedDictionary)
            
        } else {
            //ELSE RETURN THE APPROPRIATE DICTIONARY
            let safeFont: UIFont = UIFont.customFont(fontFamliy: family, forTextStyle: style) ?? .preferredFont(forTextStyle: .body)
            
            returnedDictionary = [AttrStrKey.font : safeFont, AttrStrKey.foregroundColor : UIColor(named: name)!]
            
             
            if let safeDictionary = returnedDictionary {
                

                defaults.setFontDefaults(forKey: key.rawValue, fontObject: safeDictionary)
                
            } else {
                
                print("\(#function) returned dictionary not set.")
                
                
            }
        }
        
        return returnedDictionary
    }
    
    func setFont(fontFamily family: Fonts, forTextStyle style: UIFont.TextStyle, forKey key: String) -> UIFont? {
        
        var returnedFont: UIFont?
        
        
        if family == .SystemFont {
            //IF IDENTIFER IS SYSTEM, THEN SET RETURNED FONT TO NIL
            returnedFont = nil
            //SAVE PREFERENCE TO USER DEFAULTS
            defaults.setFontDefaults(forKey: key, fontObject: returnedFont)
        } else {
            //ELSE RETURN THE APPROPRIATE FONT
            returnedFont = UIFont.customFont(fontFamliy: family, forTextStyle: style)
            //SAVE PREFERENCE TO USER DEFAULTS
            defaults.setFontDefaults(forKey: key, fontObject: returnedFont)
        }
        
        


        return returnedFont
        
    }
    
    func getFont(forKey key: String) -> UIFont? {
        
        var returnedFont: UIFont?
        
        returnedFont = defaults.getFont(forKey: key)
        
        return returnedFont
    }
    
}