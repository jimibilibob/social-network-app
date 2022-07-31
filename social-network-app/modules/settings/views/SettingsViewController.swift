//
//  SettingsViewController.swift
//  social-network-app
//
//  Created by user on 7/7/22.
//

import UIKit
import SVProgressHUD
import Kingfisher

class SettingsViewController: ImagePickerViewController {

    @IBOutlet var avatarImage: UIImageView!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var ageTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    
    lazy var viewModel = {
        SettingsViewModel()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    func setupViews() {
        view.backgroundColor = UIColor(named: "backgroundLight")
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapChangeAvatar))
        avatarImage.isUserInteractionEnabled = true
        avatarImage.addGestureRecognizer(tap)
        avatarImage.roundCorners(corners: [.allCorners], radius: 75)

        let currentUser = DefaultsManager.shared.readUser()
        
        nameTextField.text = currentUser.name
        ageTextField.text = String(currentUser.age)
        emailTextField.text = currentUser.email

        let imageProcessor = DownsamplingImageProcessor(size: avatarImage.bounds.size)
        avatarImage.kf.indicatorType = .activity
        avatarImage.kf.setImage(
            with: URL(string: currentUser.avatar),
            placeholder: UIImage(named: "placeholderImage"),
            options: [
                .processor(imageProcessor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ]
        )
        avatarImage.contentMode = .scaleAspectFill
    }

    @objc func didTapChangeAvatar() {
        showAddImageOptionAlert()
    }

    @IBAction func updateProfileAction(_ sender: Any) {
        SVProgressHUD.show()
        if let image = UIImage(data: viewModel.avatarData ?? Data()) {
            self.viewModel.uploadPostFile(file: image) { image in
                self.updateUser(imagePath: image.absoluteString)
            }
            return
        }
        self.updateUser(imagePath: "")
    }

    override func setImage(data: Data) {
        viewModel.avatarData = data
        avatarImage.roundCorners(corners: [.allCorners], radius: 50)
        avatarImage.image = UIImage(data: data)!.imageResize(sizeChange: CGSize(width: 100, height: 100))
    }

    private func updateUser(imagePath: String) {
        let currentUser = DefaultsManager.shared.readUser()
        let updatedUser = User(id: currentUser.id, name: self.nameTextField.text ?? "", age: Int(self.ageTextField.text ?? "") ?? 0, email: self.emailTextField.text ?? "",
               avatar: !imagePath.isEmpty ? imagePath : currentUser.avatar,
               password: currentUser.password, updatedAt: Date(), createdAt: currentUser.createdAt)
        self.viewModel.editUser(user: updatedUser) { user in
            DefaultsManager.shared.storeUser(user: user)
            SVProgressHUD.dismiss()
        }
    }
}
