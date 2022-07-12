//
//  PostListViewController.swift
//  social-network-app
//
//  Created by user on 5/7/22.
//

import UIKit

class PostListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        let addFriendsImage = UIImage(systemName: "person.fill.badge.plus")
        
        let addFriendsButton = UIBarButtonItem(image: addFriendsImage, style: .plain, target: self, action: #selector(addFriends))
        navigationItem.leftBarButtonItems = [addFriendsButton]
        setupTableView()
    }
    
    @objc func addFriends() {
        let chatDetail = FriendListViewController()
        show(chatDetail, sender: nil)
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: PostTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: PostTableViewCell.identifier)
    }

}

extension PostListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier) as? PostTableViewCell ?? PostTableViewCell(style: .subtitle, reuseIdentifier: PostTableViewCell.identifier)
            
        cell.postImage.image = UIImage(named: "post")!.imageResize(sizeChange: CGSize(width: 200, height: 200))
        cell.avatarImage.image = UIImage(named: "avatar")!.imageResize(sizeChange: CGSize(width: 50, height: 50))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return 350
     }
    
}
