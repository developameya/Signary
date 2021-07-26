//
//  ArrayExtension.swift
//  Signary
//
//  Created by Ameya Bhagat on 26/07/21.
//

import Foundation

extension Array where Element: Equatable {
    
    func all(where predicate: (Element) -> Bool) -> [Element] {
        return self.compactMap { predicate($0) ? $0 : nil }
    }
}
