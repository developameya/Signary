//
//  UIColorExtension.swift
//  Signary
//
//  Created by Ameya Bhagat on 15/06/21.
//

import UIKit

public typealias Colour = UIColor
//MARK:- UICOLOR: CUSTOM APP COLOURS
public extension UIColor {
    
    static var appBackground: UIColor {
        UIColor(light: UIColor(r: 242, g: 242, b: 246), dark: UIColor(r: 0, g: 0, b: 0))
    }
    
    static var appTint: UIColor {
        UIColor(light: UIColor(r: 235, g: 59, b: 90), dark: UIColor(r: 255, g: 211, b: 42))
    }
    
    static var appText: UIColor {
        UIColor(light: .label, dark: .label)
    }
}

//MARK:- UICOLOR: RANDOM METHOD
public extension UIColor {
    static func random() -> UIColor {
        return UIColor(
            red:   .random(in: 0...1),
            green: .random(in: 0...1),
            blue:  .random(in: 0...1),
            alpha: 1.0
        )
    }
}

//MARK:- UICOLOR: INIT FOR DYNAMIC COLOURS
public extension UIColor {
    
    convenience init(
        light lightModeColor: @escaping @autoclosure () -> UIColor,
        dark darkModeColor: @escaping @autoclosure () -> UIColor
    ) {
        self.init { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .light:
                return lightModeColor()
            case .dark:
                return darkModeColor()
            case .unspecified:
                return lightModeColor()
            @unknown default:
                return lightModeColor()
            }
        }
    }
}

//MARK:- UICOLOR: INIT FOR CGFLOAT VALUES
public extension UIColor {
    
    convenience init(r: Int, g: Int, b: Int, alpha: CGFloat = 1.0) {
        
        self.init(red: CGFloat(r)/255, green: CGFloat(g)/255, blue: CGFloat(b)/255, alpha: alpha)
        
    }
}
