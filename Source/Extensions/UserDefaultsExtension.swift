//
//  UserDefaultsExtension.swift
//  Signary
//
//  Created by Ameya Bhagat on 05/08/21.
//

import UIKit

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
    
    func getDynamicFontDictionary(forKey key: String) -> DynamicFontDictionary? {
        var returnedDict:DynamicFontDictionary?
        if let safeData = data(forKey: key) {
            do {
                let dictionary = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(safeData) as? DynamicFontDictionary
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
