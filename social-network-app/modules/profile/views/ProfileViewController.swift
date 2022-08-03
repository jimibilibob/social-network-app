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

    lazy var viewModel = {
        ProfileViewModel()
    }()
    
    @IBOutlet var messageButton: UIButton!
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

    @IBAction func messageAction(_ sender: Any) {
        let currentUser = DefaultsManager.shared.readUser()
        let participants = [
            Person(id: UUID().uuidString, userId: user.id, name: user.name, photo: user.avatar, updatedAt: Date(), createdAt: Date()),
            Person(id: UUID().uuidString, userId: currentUser.id, name: currentUser.name, photo: currentUser.avatar, updatedAt: Date(), createdAt: Date()),
        ]
        viewModel.getChatIfExists(participants: participants) { chat in
            if let chat = chat {
                self.show(ChatDetailViewController(chat: chat), sender: nil)
                return
            }
            self.viewModel.addNewChat(participants: participants) { result in
                switch result {
                case .success(let chat):
                    self.show(ChatDetailViewController(chat: chat), sender: nil)
                case .failure(let error):
                    print("Error:", error)
                }
            }
        }
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
        avatarImage.layer.cornerRadius = 50

        nameLabel.text = "@\(self.user.name)"

        // MARK: Show the buttons to message just in case the profile is not from the current User
        if user.id == DefaultsManager.shared.readUser().id {
            messageButton.isHidden = true
        }
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

