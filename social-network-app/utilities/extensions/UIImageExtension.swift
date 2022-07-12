//
//  UIImageExtension.swift
//  social-network-app
//
//  Created by user on 7/7/22.
//

import Foundation
import UIKit

extension UIImage {

    func imageResize (sizeChange:CGSize)-> UIImage{

        let hasAlpha = true
        let scale: CGFloat = 0.0 // Use scale factor of main screen

        UIGraphicsBeginImageContextWithOptions(sizeChange, !hasAlpha, scale)
        self.draw(in: CGRect(origin: CGPoint.zero, size: sizeChange))

        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        return scaledImage!
    }

}
