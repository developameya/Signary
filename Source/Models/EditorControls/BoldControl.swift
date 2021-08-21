//
//  BoldControl.swift
//  Signary
//
//  Created by Ameya Bhagat on 18/08/21.
//

import Foundation
import UIKit

/// Bold control toggles bold trait on the selected range in the TextView
public class BoldControl: FontTraitChangeControl {
    public init() {
        super.init(name: ControlName("BoldControl"), trait: .traitBold)
    }
}
