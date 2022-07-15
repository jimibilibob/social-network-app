//
//  ErrorAlert.swift
//  social-network-app
//
//  Created by user on 14/7/22.
//

import UIKit

class ErrorAlert: UIAlertController {

    static let shared = ErrorAlert(title: "", message: "", preferredStyle: .alert)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addAction(UIAlertAction(title: "Ok", style: .default))
    }
    
    func showAlert(title: String, message: String = "", target: UIViewController) {
        self.title = title
        self.message = message
        
        target.navigationController?.present(self, animated: true)
    }
}
