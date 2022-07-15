//
//  ConfirmAlertViewController.swift
//  social-network-app
//
//  Created by user on 14/7/22.
//

import UIKit

import UIKit

class ConfirmAlert: UIAlertController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addAction(UIAlertAction(title: "No", style: .cancel))
    }
    
    func showAlert(target: UIViewController, onConfirm: @escaping () -> Void) {
        self.title = title
        self.message = message
        
        self.addAction(UIAlertAction(title: "Yes", style: .default) { _ in
            onConfirm()
        })
        
        target.navigationController?.present(self, animated: true)
    }
}

