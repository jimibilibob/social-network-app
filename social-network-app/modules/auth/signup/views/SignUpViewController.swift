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
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var signupButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    @IBAction func loginAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func signUpAction(_ sender: Any) {
        guard let userName = usernameTextField.text,
              let password = passwordTextField.text else { return }
        AuthFirebaseManager.shared.signUp(userName: userName, password: password, completion: { result in
            switch result {
            case .success(let user):
                DefaultsManager.shared.storeUser(user: user)
                SceneDelegate.shared?.setupRootControllerIfNeeded(validUser: false)
                self.navigationController?.popToRootViewController(animated: true)
            case .failure(let error):
                print("Error while login \(error)")
            }
        })
    }

    func setupViews() {
        formView.layer.cornerRadius = 15
        usernameTextField.layer.cornerRadius = 15
        usernameTextField.clipsToBounds = true
        passwordTextField.layer.cornerRadius = 15
        passwordTextField.clipsToBounds = true
        passwordTextField.isSecureTextEntry = true
        signupButton.layer.cornerRadius = 15
        signupButton.clipsToBounds = true
        navigationController?.isNavigationBarHidden = true
    }
}
