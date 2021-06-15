//
//  UIColorExtension.swift
//  Signary
//
//  Created by Ameya Bhagat on 15/06/21.
//

import UIKit

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
