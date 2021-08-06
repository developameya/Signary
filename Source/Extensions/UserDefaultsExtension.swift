//
//  UserDefaultsExtension.swift
//  Signary
//
//  Created by Ameya Bhagat on 05/08/21.
//

import UIKit

typealias AttrStrKey = NSAttributedString.Key
typealias FontFormattingDictionary = [ AttrStrKey : Any]

extension UserDefaults {
    
    func setFontDefaults(forKey key: String, fontObject: Any?) {
        
        var fontData: NSData?
        
        if let safeFontObject = fontObject {
            
            do {
                
                let data = try NSKeyedArchiver.archivedData(withRootObject: safeFontObject, requiringSecureCoding: false) as NSData?
                
                fontData = data
                
            } catch {
                
                print("\(#function) Error converting font to NSData")
                
            }
        }
        
        setValue(fontData, forKey: key)
    }
    
    func getFontFormattingDictionary(forKey key: String) -> FontFormattingDictionary? {
        
        var returnedDict:FontFormattingDictionary?
        
        if let safeData = data(forKey: key) {
            
            do {
                
                let dictionary = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(safeData) as? FontFormattingDictionary
                
                returnedDict = dictionary
                
            } catch {
                
                print("\(#line)--\(#function) Error unarchiving dictionary as NSData.")
                
            }
        }
        
        return returnedDict
        
    }
    
    func getFont(forKey key: String) -> UIFont? {
        
        var returnedFont: UIFont?
        
        if let safeData = data(forKey: key) {
            
            do {
                
                let font = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(safeData) as? UIFont
                
                returnedFont = font
                
            } catch {
                
                print("\(#line)--\(#function) Error unarchiving font as NSData.")
                
            }
        }
        return returnedFont
    }
}
