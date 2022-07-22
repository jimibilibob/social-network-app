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
    @IBOutlet weak var usernameTextField: UITextField!
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
        guard let userName = usernameTextField.text,
              let password = passwordTextField.text else { return }
        AuthFirebaseManager.shared.login(userName: userName, password: password, completion: { result in
            switch result {
            case .success(let user):
                let homeController = SceneDelegate.shared?.getRootViewControllerForValidUser()
                print("Success login \(user)")
                DefaultsManager.shared.storeUser(user: user)
                if let hc = homeController {
                    self.show(hc, sender: nil)
                }
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
        loginButton.layer.cornerRadius = 15
        loginButton.clipsToBounds = true
        navigationController?.isNavigationBarHidden = true
    }
}
