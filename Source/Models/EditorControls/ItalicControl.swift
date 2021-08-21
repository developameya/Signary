//
//  ItalicControl.swift
//  Signary
//
//  Created by Ameya Bhagat on 18/08/21.
//

import Foundation

class ItalicControl: FontTraitChangeControl {
    public init() {
        super.init(name: ControlName("ItalicControl"), trait: .traitItalic)
    }
}
