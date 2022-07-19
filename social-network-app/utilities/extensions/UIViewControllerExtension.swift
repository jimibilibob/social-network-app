//
//  UIViewControllerExtension.swift
//  social-network-app
//
//  Created by user on 18/7/22.
//

import Foundation
import UIKit

extension UIViewController {

    func showToast(message: String, seconds: Double) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.view.backgroundColor = .black
        alert.view.alpha = 0.5
        alert.view.layer.cornerRadius = 15
        self.present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            alert.dismiss(animated: true, completion: nil)
        }
    }

}
