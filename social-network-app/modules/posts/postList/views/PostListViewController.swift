//
//  PostListViewController.swift
//  social-network-app
//
//  Created by user on 5/7/22.
//

import UIKit

class PostListViewController: ImagePickerViewController {

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
        guard let image = UIImage(data: data) else { return }
        viewModel.uploadPostFile(file: image) { image in
            let newPost = Post(id: UUID().uuidString, photo: image.absoluteString, ownerId: UUID().uuidString, updatedAt: Date(), createdAt: Date())
            self.viewModel.addNewPost(post: newPost) { result in
                switch result {
                case .success(let post):
                    print("NEW POST AVIABLE", post)
                    self.tableView.reloadData()
                case .failure(let error):
                    print("ERROR WHILE ADDING A NEW POST", error)
                }
            }
        }
    }

}

extension PostListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier) as? PostTableViewCell ?? PostTableViewCell(style: .subtitle, reuseIdentifier: PostTableViewCell.identifier)
            
        //cell.postImage.image = UIImage(named: "post")!.imageResize(sizeChange: CGSize(width: 200, height: 200))
        let post = viewModel.posts[indexPath.row]
        if let url = URL(string: post.photo) {
            ImageManager.shared.loadImage(from: url) { result in
                switch result {
                case .success(let uiImage):
                    cell.postImage.image = uiImage
                case .failure(let error):
                    print("Error while getting post image", error)
                }
            }
        }
        cell.avatarImage.image = UIImage(named: "avatar")!.imageResize(sizeChange: CGSize(width: 50, height: 50))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return 350
     }
    
}

