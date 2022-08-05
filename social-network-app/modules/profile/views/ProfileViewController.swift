//
//  ProfileViewController.swift
//  social-network-app
//
//  Created by user on 10/7/22.
//

import UIKit
import SVProgressHUD
import Kingfisher

class ProfileViewController: ImagePickerViewController {
    var user: User
    var viewModel: ProfileViewModel
    
    @IBOutlet var friendsLabel: UILabel!
    @IBOutlet var addPostButton: UIButton!
    @IBOutlet var messageButton: UIButton!
    @IBOutlet var avatarImage: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        loadPosts()
        setFriendsLabel()
    }

    override func viewWillAppear(_ animated: Bool) {
        if user.id == DefaultsManager.shared.readUser().id {
            user = DefaultsManager.shared.readUser()
        }
        setupViews()
        loadPosts()
        setFriendsLabel()
    }

    init(user: User = DefaultsManager.shared.readUser()) {
        self.user = user
        self.viewModel = ProfileViewModel(user: user)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func loadPosts() {
        viewModel.getAllPosts(by: user.id) { result in
            switch result {
            case .success(let posts):
                self.viewModel.posts = posts
                self.loadReactions(posts: posts)
            case .failure(let error):
                ErrorAlert.shared.showAlert(title: "Error while fetching posts", message: error.localizedDescription, target: self)
            }
        }
    }

    func loadReactions(posts: [Post]) {
        viewModel.getAllReactions(posts: posts) { result in
            switch result {
            case .success(let reactions):
                self.viewModel.reactions = reactions
                self.tableView.reloadData()
            case .failure(let error):
                ErrorAlert.shared.showAlert(title: "Error while fetching reactions", message: error.localizedDescription, target: self)
            }
        }
    }

    func setFriendsLabel() {
        viewModel.getAllAcceptedFriends(user: user) { friends in
            self.friendsLabel.text = "\(friends.count) Friends"
        }
    }

    @IBAction func addPostAction(_ sender: Any) {
        showAddImageOptionAlert()
    }

    @IBAction func messageAction(_ sender: Any) {
        let currentUser = DefaultsManager.shared.readUser()
        let participants = [
            Person(id: UUID().uuidString, userId: user.id, name: user.name, photo: user.avatar, updatedAt: Date(), createdAt: Date()),
            Person(id: UUID().uuidString, userId: currentUser.id, name: currentUser.name, photo: currentUser.avatar, updatedAt: Date(), createdAt: Date()),
        ]
        viewModel.getChatIfExists(user: user, participants: participants) { chat in
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
        addPostButton.roundCorners(corners: [.allCorners], radius: 25)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: PostTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: PostTableViewCell.identifier)
        viewModel.reloadTable = tableView.reloadData

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
        } else {
            addPostButton.isHidden = true
        }
    }

    override func setImage(data: Data) {
        let vc = PostDetailViewController()
        vc.post = Post(id: UUID().uuidString, photo: "", description: "",ownerId: DefaultsManager.shared.readUser().id, updatedAt: Date(), createdAt: Date())
        viewModel.postData = data
        vc.dataImage = data
        vc.delegate = self
        show(vc, sender: nil)
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier) as? PostTableViewCell ?? PostTableViewCell(style: .subtitle, reuseIdentifier: PostTableViewCell.identifier)

        let post = viewModel.posts[indexPath.row]
        let url = URL(string: post.photo)
        let processor = DownsamplingImageProcessor(size: cell.postImage.bounds.size)
        cell.postImage.kf.indicatorType = .activity
        cell.postImage.kf.setImage(
            with: url,
            placeholder: UIImage(named: "placeholderImage"),
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ]
        )

        // Avatar Image
        let imageProcessor = DownsamplingImageProcessor(size: cell.avatarImage.frame.size)
        cell.avatarImage.kf.indicatorType = .activity
        cell.avatarImage.kf.setImage(
            with: URL(string: user.avatar),
            placeholder: UIImage(named: "placeholderImage"),
            options: [
                .processor(imageProcessor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ]
        )
        cell.avatarImage.contentMode = .scaleAspectFill
        cell.delegate = self
        cell.nameLabel.text = user.name
        cell.userNameLabel.text = "@\(user.name)"
        
        let hasReacted = viewModel.hasReacted(userId: DefaultsManager.shared.readUser().id, post: post)
        cell.setUpReactionSection(hasReacted: hasReacted, reactionsCounter: viewModel.reactionCount(post: post))
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard user.id == DefaultsManager.shared.readUser().id else { return }
        let vc = PostDetailViewController()
        let post = viewModel.posts[indexPath.row]
        vc.post = post
        vc.delegate = self
        show(vc, sender: nil)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return 350
     }
}

extension ProfileViewController: PostDetailViewControllerDelegate {
    func savePost(post: Post) {
        SVProgressHUD.show()
        guard let image = UIImage(data: viewModel.postData ?? Data()) else { return }
        self.viewModel.uploadPostFile(file: image) { image in
            let newPost = Post(id: post.id, photo: image.absoluteString, description: post.description, ownerId: post.ownerId, updatedAt: post.updatedAt, createdAt: post.createdAt)
            self.viewModel.addNewPost(post: newPost) { result in
                switch result {
                case .success(_):
                    // self.tableView.reloadData()
                    self.navigationController?.popToRootViewController(animated: true)
                    self.showToast(message: "New post created!", seconds: 2)
                case .failure(_):
                    ErrorAlert.shared.showAlert(title: "Error ", message: "Error while posting, please try again later.", target: self)
                }
                SVProgressHUD.dismiss()
            }
        }
    }
    
    func updatePost(post: Post) {
        SVProgressHUD.show()
        self.viewModel.editPost(post: post) { post in
            self.navigationController?.popToRootViewController(animated: true)
            SVProgressHUD.dismiss()
            self.showToast(message: "Post edited successfully!", seconds: 2)
        }
    }
}

extension ProfileViewController: PostTableViewCellDelegate {
    func react(cell: PostTableViewCell) {
        guard let indexPath = self.tableView.indexPath(for: cell) else { return }
        let reactedPost = viewModel.posts[indexPath.row]
        let hasReacted = viewModel.hasReacted(userId: DefaultsManager.shared.readUser().id, post: reactedPost)
        if !hasReacted {
            viewModel.addReaction(reaction: Reaction(id: UUID().uuidString, postId: reactedPost.id, ownerId: DefaultsManager.shared.readUser().id, updatedAt: Date(), createdAt: Date()))
            return
        }
        let reactions = viewModel.reactions.filter({ $0.postId == reactedPost.id &&
            $0.ownerId == DefaultsManager.shared.readUser().id
        })
        if !reactions.isEmpty {
            viewModel.removeReaction(reactionId: reactions[0].id)
        }
        self.tableView.reloadRows(at: [indexPath], with: .none)
    }
}
