//
//  PostDetailViewController.swift
//  social-network-app
//
//  Created by user on 17/7/22.
//

import UIKit
import Kingfisher

class PostDetailViewController: UIViewController {
    
    var post: Post?
    var dataImage: Data?
    weak var delegate: PostDetailViewControllerDelegate?

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
        let url = URL(string: post?.photo ?? "")
        let processor = DownsamplingImageProcessor(size: postImage.bounds.size)
                     |> RoundCornerImageProcessor(cornerRadius: 25)
        postImage.kf.indicatorType = .activity
        postImage.kf.setImage(
            with: url,
            placeholder: UIImage(named: "placeholderImage"),
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ]
        )
        if let dataImage = dataImage {
            postImage.image = UIImage(data: dataImage )
        }
        
        // Avatar Image
        let imageProcessor = DownsamplingImageProcessor(size: avatarImage.bounds.size)
        avatarImage.kf.indicatorType = .activity
        avatarImage.kf.setImage(
            with: URL(string: DefaultsManager.shared.readUser().avatar),
            placeholder: UIImage(named: "placeholderImage"),
            options: [
                .processor(imageProcessor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ]
        )
        avatarImage.contentMode = .scaleAspectFill
        nameLabel.text = DefaultsManager.shared.readUser().name
        postImage.contentMode = .scaleToFill
        postImage.layer.cornerRadius = 25
        postDescriptionTextField.text = post?.description

        //avatarImage.image = UIImage(named: "avatar")!.imageResize(sizeChange: CGSize(width: 50, height: 50))
        nameLabel.text = DefaultsManager.shared.readUser().name
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
