//
//  UIColorExtension.swift
//  Signary
//
//  Created by Ameya Bhagat on 15/06/21.
//

import UIKit

public typealias Colour = UIColor

public extension Colour {
    //MARK:- UICOLOR: CUSTOM APP COLOURS
    static var appBackgroundColour: Colour {
        Colour(light: Colour(r: 242, g: 242, b: 246), dark: Colour(r: 0, g: 0, b: 0))
    }
    
    static var appTintColour: Colour {
        Colour(light: Colour(r: 235, g: 59, b: 90), dark: Colour(r: 255, g: 211, b: 42))
    }
    
    static var appTextColour: Colour {
        Colour(light: .label, dark: .label)
    }
    
    //MARK:- UICOLOR: RANDOM METHOD
    static func random() -> Colour {
        return Colour(
            red:   .random(in: 0...1),
            green: .random(in: 0...1),
            blue:  .random(in: 0...1),
            alpha: 1.0
        )
    }
    
    //MARK:- UICOLOR: INIT FOR DYNAMIC COLOURS
    convenience init(
        light lightModeColor: @escaping @autoclosure () -> Colour,
        dark darkModeColor: @escaping @autoclosure () -> Colour
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
    
    //MARK:- UICOLOR: INIT FOR CGFLOAT VALUES
    convenience init(r: Int, g: Int, b: Int, alpha: CGFloat = 1.0) {
        
        self.init(red: CGFloat(r)/255, green: CGFloat(g)/255, blue: CGFloat(b)/255, alpha: alpha)
        
    }
}
