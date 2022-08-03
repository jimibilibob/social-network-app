//
//  SignUpViewController.swift
//  social-network-app
//
//  Created by user on 21/7/22.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet var formView: UIView!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var signupButton: UIButton!
    @IBOutlet var emailTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    @IBAction func loginAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func signUpAction(_ sender: Any) {
        guard let name = nameTextField.text, !name.isEmpty,
              let password = passwordTextField.text, !password.isEmpty,
              let email = emailTextField.text, !email.isEmpty else {
            ErrorAlert.shared.showAlert(title: "All fields are required!", target: self)
            return
        }
        guard name.count > 2 else {
            ErrorAlert.shared.showAlert(title: "Name must have at least 3 characters!", target: self)
            return
        }
        guard email.isValidEmail else {
            ErrorAlert.shared.showAlert(title: "Invalid email", target: self)
            return
        }
        guard password.count > 5 else {
            ErrorAlert.shared.showAlert(title: "Password must have at least 5 characters!", target: self)
            return
        }
        AuthFirebaseManager.shared.signUp(name: name, email: email, password: password, completion: { result in
            switch result {
            case .success(let user):
                DefaultsManager.shared.storeUser(user: user)
                SceneDelegate.shared?.setupRootControllerIfNeeded(validUser: true)
                self.navigationController?.popToRootViewController(animated: true)
            case .failure(let error):
                ErrorAlert.shared.showAlert(title: "\(error)", target: self)
            }
        })
    }

    func setupViews() {
        formView.layer.cornerRadius = 15
        nameTextField.layer.cornerRadius = 15
        nameTextField.clipsToBounds = true
        passwordTextField.layer.cornerRadius = 15
        passwordTextField.clipsToBounds = true
        passwordTextField.isSecureTextEntry = true
        signupButton.layer.cornerRadius = 15
        signupButton.clipsToBounds = true
        navigationController?.isNavigationBarHidden = true
    }
}
