//
//  LoginViewController.swift
//  social-network-app
//
//  Created by user on 3/7/22.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var formView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    @IBAction func registerAction(_ sender: Any) {
        let vc = SignUpViewController()
        show(vc, sender: nil)
    }

    @IBAction func loginAction(_ sender: Any) {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            ErrorAlert.shared.showAlert(title: "All fields are required!", target: self)
            return
        }
        guard email.isValidEmail else {
            ErrorAlert.shared.showAlert(title: "Invalid email", target: self)
            return
        }
        AuthFirebaseManager.shared.login(email: email, password: password, completion: { result in
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
        emailTextField.layer.cornerRadius = 15
        emailTextField.clipsToBounds = true
        passwordTextField.layer.cornerRadius = 15
        passwordTextField.clipsToBounds = true
        passwordTextField.isSecureTextEntry = true
        loginButton.layer.cornerRadius = 15
        loginButton.clipsToBounds = true
        navigationController?.isNavigationBarHidden = true
    }
}
