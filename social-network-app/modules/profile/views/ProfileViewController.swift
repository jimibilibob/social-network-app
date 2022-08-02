//
//  ProfileViewController.swift
//  social-network-app
//
//  Created by user on 10/7/22.
//

import UIKit
import Kingfisher

class ProfileViewController: UIViewController {
    var user: User
    
    @IBOutlet var avatarImage: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    init(user: User = DefaultsManager.shared.readUser()) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: SHOW WHEN IS NOT THE PROFILE OWNER
    @IBAction func addFriendAction(_ sender: Any) {
        // TODO: Add friend
    }

    @IBAction func messageAction(_ sender: Any) {
        // TODO: Send Message
    }
    func setupViews() {
        title = self.user.name
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: PostTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: PostTableViewCell.identifier)

        let imageProcessor = DownsamplingImageProcessor(size: avatarImage.bounds.size)
        avatarImage.kf.indicatorType = .activity
        avatarImage.kf.setImage(
            with: URL(string: self.user.avatar),
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

        nameLabel.text = "@\(self.user.name)"
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

