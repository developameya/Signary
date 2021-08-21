//
//  ControlName.swift
//  Signary
//
//  Created by Ameya Bhagat on 17/08/21.
//

import Foundation

public struct ControlName: Hashable, Equatable, RawRepresentable {
    ///Name the `Control`, must be unique across different types of controls
    public let rawValue: String
    
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
    
    public init(_ rawValue: String) {
        self.init(rawValue: rawValue)
    }
}
