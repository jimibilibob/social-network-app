//
//  StringExtension.swift
//  social-network-app
//
//  Created by user on 10/7/22.
//

import Foundation
import UIKit

extension String {
    func sizeOfString( font: UIFont) -> CGSize {
        let fontAttribute = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttribute)  // for Single Line
       return size;
    }
}
