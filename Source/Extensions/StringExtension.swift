//
//  StringExtension.swift
//  Signary
//
//  Created by Ameya Bhagat on 17/06/21.
//

import UIKit

extension String {
    public var lines: [String] { return self.components(separatedBy: NSCharacterSet.newlines) }
}
