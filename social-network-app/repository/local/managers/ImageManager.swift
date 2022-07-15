//
//  ImageManager.swift
//  social-network-app
//
//  Created by user on 14/7/22.
//

import Foundation
import UIKit

class ImageManager {
    static let shared = ImageManager()
    
    func loadImage(from url: URL, completion: @escaping (Result<UIImage, Error>)-> Void) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.sync {
                        completion(.success(image))
                    }
                }
            }
        }
    }
}
