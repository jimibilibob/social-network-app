//
//  PostListViewController.swift
//  social-network-app
//
//  Created by user on 5/7/22.
//

import UIKit
import SVProgressHUD
import Kingfisher

class PostListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    lazy var viewModel = {
        PostTableViewModel()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupTableView()
        loadPosts()
    }

    override func viewWillAppear(_ animated: Bool) {
        loadPosts()
        tableView.reloadData()
    }

    @objc func addFriends() {
        let chatDetail = FriendListViewController()
        show(chatDetail, sender: nil)
    }

    @objc func signOut() {
        SceneDelegate.shared?.setupRootControllerIfNeeded(validUser: false)
        DefaultsManager.shared.deleteUser()
        navigationController?.popToRootViewController(animated: true)
    }

    func loadPosts() {
        viewModel.getPeople() { _ in
            self.viewModel.getAllPosts() { result in
                switch result {
                case .success(let posts):
                    self.viewModel.posts = posts
                    self.loadReactions(posts: posts)
                case .failure(let error):
                    ErrorAlert.shared.showAlert(title: "Error while fetching posts", message: error.localizedDescription, target: self)
                }
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

    func setupViews() {
        // AddFriends Button
        let addFriendsImage = UIImage(systemName: "person.fill.badge.plus")
        let addFriendsButton = UIBarButtonItem(image: addFriendsImage, style: .plain, target: self, action: #selector(addFriends))
        navigationItem.leftBarButtonItems = [addFriendsButton]

        // Sign out button
        let signOutImaget = UIImage(systemName: "rectangle.portrait.and.arrow.right")
        let signOutButton = UIBarButtonItem(image: signOutImaget, style: .plain, target: self, action: #selector(signOut))
        navigationItem.rightBarButtonItems = [signOutButton]
        
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        viewModel.reloadTable = tableView.reloadData
        
        tableView.register(UINib(nibName: PostTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: PostTableViewCell.identifier)
    }
}

extension PostListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier) as? PostTableViewCell ?? PostTableViewCell(style: .subtitle, reuseIdentifier: PostTableViewCell.identifier)

        let post = viewModel.posts[indexPath.row]
        let url = URL(string: post.photo)
        let processor = DownsamplingImageProcessor(size: cell.postImage.bounds.size)
                     |> RoundCornerImageProcessor(cornerRadius: 25)
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
        let postOwner = viewModel.getPostOwner(post: post)
        guard let postOwner = postOwner else {
            return cell
        }

        let imageProcessor = DownsamplingImageProcessor(size: cell.avatarImage.frame.size)
        cell.avatarImage.kf.indicatorType = .activity
        cell.avatarImage.kf.setImage(
            with: URL(string: postOwner.avatar),
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
        cell.nameLabel.text = postOwner.name
        
        let hasReacted = viewModel.hasReacted(userId: DefaultsManager.shared.readUser().id, post: post)
        cell.setUpReactionSection(hasReacted: hasReacted, reactionsCounter: viewModel.reactionCount(post: post))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return 350
     }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

extension PostListViewController: PostTableViewCellDelegate {
    func react(cell: PostTableViewCell) {
        guard let indexPath = self.tableView.indexPath(for: cell) else { return }
        let reactedPost = viewModel.posts[indexPath.row]
        let hasReacted = viewModel.hasReacted(userId: DefaultsManager.shared.readUser().id, post: reactedPost)
        // TODO: Check when a User remove an reaction, sometimes removes the other person reaction
        if !hasReacted {
            viewModel.addReaction(reaction: Reaction(id: UUID().uuidString, postId: reactedPost.id, ownerId: DefaultsManager.shared.readUser().id, updatedAt: Date(), createdAt: Date()))
            return
        }
        let reactions = viewModel.reactions.filter({ $0.postId == reactedPost.id })
        if !reactions.isEmpty {
            viewModel.removeReaction(reactionId: reactions[0].id)
        }
        self.tableView.reloadRows(at: [indexPath], with: .none)
    }
}
