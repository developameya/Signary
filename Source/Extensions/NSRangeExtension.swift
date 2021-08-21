//
//  NSRangeExtension.swift
//  Signary
//
//  Created by Ameya Bhagat on 17/08/21.
//

import Foundation

public extension NSRange {
    /// Range with 0 location and length
    static var zero: NSRange {
        return NSRange(location: 0, length: 0)
    }
    
}
