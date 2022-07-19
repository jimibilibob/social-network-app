//
//  PostListViewController.swift
//  social-network-app
//
//  Created by user on 5/7/22.
//

import UIKit
import SVProgressHUD
import Kingfisher

class PostListViewController: ImagePickerViewController {
    
    var hasReacted = false
    

    @IBOutlet var addPostButton: UIButton!
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
    
    @IBAction func addPostAction(_ sender: Any) {
        showAddImageOptionAlert()
    }
    @objc func addFriends() {
        let chatDetail = FriendListViewController()
        show(chatDetail, sender: nil)
    }
    
    func loadPosts() {
        viewModel.reloadTable = tableView.reloadData
        viewModel.getAllPosts()
    }
    
    func setupViews() {
        addPostButton.roundCorners(corners: [.allCorners], radius: 25)

        let addFriendsImage = UIImage(systemName: "person.fill.badge.plus")
        let addFriendsButton = UIBarButtonItem(image: addFriendsImage, style: .plain, target: self, action: #selector(addFriends))
        navigationItem.leftBarButtonItems = [addFriendsButton]
        
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: PostTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: PostTableViewCell.identifier)
    }
    
    override func setImage(data: Data) {
        let vc = PostDetailViewController()
        vc.post = Post(id: UUID().uuidString, photo: "", description: "", ownerId: UUID().uuidString, updatedAt: Date(), createdAt: Date())
        viewModel.postData = data
        vc.dataImage = data
        vc.delegate = self
        show(vc, sender: nil)
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
        cell.delegate = self
        cell.avatarImage.image = UIImage(named: "avatar")!.imageResize(sizeChange: CGSize(width: 50, height: 50))
        cell.setUpReactionSection(hasReacted: hasReacted)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return 350
     }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = PostDetailViewController()
        let post = viewModel.posts[indexPath.row]
        vc.post = post
        vc.delegate = self
        show(vc, sender: nil)
    }
}

extension PostListViewController: PostDetailViewControllerDelegate {
    func savePost(post: Post) {
        SVProgressHUD.show()
        guard let image = UIImage(data: viewModel.postData ?? Data()) else { return }
        self.viewModel.uploadPostFile(file: image) { image in
            let newPost = Post(id: post.id, photo: image.absoluteString, description: post.description, ownerId: post.ownerId, updatedAt: post.updatedAt, createdAt: post.createdAt)
            self.viewModel.addNewPost(post: newPost) { result in
                switch result {
                case .success(_):
                    self.tableView.reloadData()
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
            self.tableView.reloadData()
            self.navigationController?.popToRootViewController(animated: true)
            SVProgressHUD.dismiss()
            self.showToast(message: "Post edited successfully!", seconds: 2)
        }
    }
}

extension PostListViewController: PostTableViewCellDelegate {
    func react(cell: PostTableViewCell) {
        hasReacted = !hasReacted
        guard let indexPath = self.tableView.indexPath(for: cell) else { return }
        tableView.reloadRows(at: [indexPath], with: .none)
    }
}
