//
//  CustomFontController.swift
//  Signary
//
//  Created by Ameya Bhagat on 02/08/21.
//

import UIKit

public typealias AttrStrKey = NSAttributedString.Key
public typealias DynamicFontDictionary = [ AttrStrKey : Any]

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
    
    func getFontAttributes(forKey key: fontAttributes) -> DynamicFontDictionary? {
        
        let stringKey = key.rawValue
        
        return defaults.getDynamicFontDictionary(forKey: stringKey)
        
    }
    
    func setFontAttributes(forKey key: fontAttributes, fontFamily family: CustomFonts, forTextStyle style: TextStyle, textColourName name: String = "editorTextColour") -> DynamicFontDictionary? {
        
        var returnedDictionary: DynamicFontDictionary?
        
        if family == .SystemFont {
            //IF FAMILY IS SET TO SYSTEM, RETURN NIL
            returnedDictionary = nil
            //SAVE PREFERENCE TO USER DEFAULTS
            defaults.setFontDefaults(forKey: key.rawValue, fontObject: returnedDictionary)
            
        } else {
            //ELSE RETURN THE APPROPRIATE DICTIONARY
            let customFont = Font.customFont(name: family.rawValue)
            let safeFont = Font.preferredCustom(font: customFont!, textStyle: style) ?? .preferredFont(forTextStyle: .body)
            returnedDictionary = [AttrStrKey.font : safeFont, AttrStrKey.foregroundColor : UIColor(named: name)!]
            
             
            if let safeDictionary = returnedDictionary {
                

                defaults.setFontDefaults(forKey: key.rawValue, fontObject: safeDictionary)
                
            } else {
                
                print("\(#function) returned dictionary not set.")
                
                
            }
        }
        
        return returnedDictionary
    }
    
    func setFont(fontFamily family: CustomFonts, forTextStyle style: TextStyle, forKey key: String) -> Font? {
        
        var returnedFont: Font?
        
        
        if family == .SystemFont {
            //IF IDENTIFER IS SYSTEM, THEN SET RETURNED FONT TO NIL
            returnedFont = nil
            //SAVE PREFERENCE TO USER DEFAULTS
            defaults.setFontDefaults(forKey: key, fontObject: returnedFont)
        } else {
            //ELSE RETURN THE APPROPRIATE FONT
            let font = Font.customFont(name: family.rawValue)
            returnedFont = Font.preferredCustom(font: font!, textStyle: style)
            //SAVE PREFERENCE TO USER DEFAULTS
            defaults.setFontDefaults(forKey: key, fontObject: returnedFont)
        }
        return returnedFont
    }
    
    func getFont(forKey key: String) -> Font? {
        
        var returnedFont: Font?
        
        returnedFont = defaults.getFont(forKey: key)
        
        return returnedFont
    }
}
