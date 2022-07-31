//
//  ProfileViewController.swift
//  social-network-app
//
//  Created by user on 10/7/22.
//

import UIKit
import Kingfisher

class ProfileViewController: UIViewController {

    @IBOutlet var avatarImage: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    // MARK: SHOW WHEN IS NOT THE PROFILE OWNER
    @IBAction func addFriendAction(_ sender: Any) {
        // TODO: Add friend
    }

    @IBAction func messageAction(_ sender: Any) {
        // TODO: Send Message
    }
    func setupViews() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: PostTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: PostTableViewCell.identifier)

        let currentUser = DefaultsManager.shared.readUser()
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
        avatarImage.layer.cornerRadius = 110

        nameLabel.text = "@\(currentUser.name)"
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier, for: indexPath) as? PostTableViewCell ?? PostTableViewCell()
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return 350
     }
}

