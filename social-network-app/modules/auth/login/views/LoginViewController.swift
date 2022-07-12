//
//  SignUpViewController.swift
//  social-network-app
//
//  Created by user on 3/7/22.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var formView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        formView.layer.cornerRadius = 35
        usernameTextField.layer.cornerRadius = 25
        usernameTextField.clipsToBounds = true
        passwordTextField.layer.cornerRadius = 25
        passwordTextField.clipsToBounds = true
        loginButton.layer.cornerRadius = 25
        loginButton.clipsToBounds = true
    }

}
