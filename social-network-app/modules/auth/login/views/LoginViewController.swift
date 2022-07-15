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
        
        setupViews()
    }

    @IBAction func loginAction(_ sender: Any) {
        guard let userName = usernameTextField.text,
              let password = passwordTextField.text else { return }
        AuthFirebaseManager.shared.signUp(userName: userName, password: password, completion: { result in
            switch result {
            case .success(let user):
                let homeController = SceneDelegate.shared?.getRootViewControllerForValidUser()
                print("Success login \(user)")
                if let hc = homeController {
                    self.show(hc, sender: nil)
                }
            case .failure(let error):
                print("Error while login \(error)")
            }
        })
    }

    func setupViews() {
        formView.layer.cornerRadius = 35
        usernameTextField.layer.cornerRadius = 25
        usernameTextField.clipsToBounds = true
        passwordTextField.layer.cornerRadius = 25
        passwordTextField.clipsToBounds = true
        passwordTextField.isSecureTextEntry = true
        loginButton.layer.cornerRadius = 25
        loginButton.clipsToBounds = true
        navigationController?.isNavigationBarHidden = true
    }
}
