//
//  PostDetailViewController.swift
//  social-network-app
//
//  Created by user on 17/7/22.
//

import UIKit

class PostDetailViewController: UIViewController {
    
    var post: Post?
    var dataImage: Data?
    var delegate: PostDetailViewControllerDelegate?

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
        title = (dataImage != nil)
                ? "New Post" : "Update Post"

        let newPostImage = UIImage(systemName: "checkmark")
        let newPostButton = UIBarButtonItem(image: newPostImage, style: .plain, target: self, action: #selector(addOrUpdatePost))
        navigationItem.rightBarButtonItems = [newPostButton]

        mainBackgroundView.backgroundColor = UIColor(named: "backgroundLight")
        avatarImage.roundCorners(corners: [.allCorners], radius: 25)
        
        // Initialize with post values
        if let url = URL(string: post?.photo ?? "") {
            ImageManager.shared.loadImage(from: url) { result in
                switch result {
                case .success(let uiImage):
                    self.postImage.image  = uiImage
                case .failure(let error):
                    print("Error while getting post image", error)
                }
            }
        }
        postImage.image = UIImage(data: dataImage ?? Data())
        postImage.contentMode = .scaleToFill
        postImage.layer.cornerRadius = 25
        postDescriptionTextField.text = post?.description

        avatarImage.image = UIImage(named: "avatar")!.imageResize(sizeChange: CGSize(width: 50, height: 50))
        nameLabel.text = "Saih Nahni"
        /*avatarImage.image = UIImage(named: "avatar")!.imageResize(sizeChange: CGSize(width: 50, height: 50))
        nameLabel.text = "Saih Nahni"*/
    }

    @objc func addOrUpdatePost() {
        guard let post = post else { return }
        let newPost = Post(id: post.id, photo: post.photo, description: postDescriptionTextField.text ?? "", ownerId: post.ownerId, updatedAt: Date(), createdAt: post.createdAt)
        dataImage != nil
            ? delegate?.savePost(post: newPost)
            : delegate?.updatePost(post: newPost)
    }
}

protocol PostDetailViewControllerDelegate: AnyObject {
    func savePost(post: Post)
    func updatePost(post: Post)
}
