//
//  ArrayExtension.swift
//  social-network-app
//
//  Created by user on 2/8/22.
//

import Foundation

extension Array where Element: Comparable {
    func containsSameElements(as other: [Element]) -> Bool {
        return self.count == other.count && self.sorted() == other.sorted()
    }
}
