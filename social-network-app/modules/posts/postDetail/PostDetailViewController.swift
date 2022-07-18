//
//  PostDetailViewController.swift
//  social-network-app
//
//  Created by user on 17/7/22.
//

import UIKit

class PostDetailViewController: UIViewController {
    
    var post: Post?
    var checkMarkAction: (() -> Void)?

    @IBOutlet var postDescriptionTextField: UITextField!
    @IBOutlet var postImage: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var avatarImage: UIImageView!
    @IBOutlet var mainBackgroundView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews() {
        title = "New Post"

        let newPostImage = UIImage(systemName: "checkmark")
        let newPostButton = UIBarButtonItem(image: newPostImage, style: .plain, target: self, action: #selector(addPost))
        navigationItem.rightBarButtonItems = [newPostButton]

        mainBackgroundView.backgroundColor = UIColor(named: "backgroundLight")
        avatarImage.roundCorners(corners: [.allCorners], radius: 25)
        
        // Initialize with post values
        postImage.image = UIImage(named: "post")
        avatarImage.image = UIImage(named: "avatar")!.imageResize(sizeChange: CGSize(width: 50, height: 50))
        nameLabel.text = "Saih Nahni"
        postDescriptionTextField.text = "askdljhalskdh  lkjahsdjh asdlh klj"
    }

    @objc func addPost() {
        checkMarkAction?()
    }
}
