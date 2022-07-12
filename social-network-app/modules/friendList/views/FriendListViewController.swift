//
//  FriendListViewController.swift
//  social-network-app
//
//  Created by user on 7/7/22.
//

import UIKit

class FriendListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: FriendTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: FriendTableViewCell.identifier)
    }
}

extension FriendListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FriendTableViewCell.identifier, for: indexPath) as? FriendTableViewCell ?? FriendTableViewCell(style: .default, reuseIdentifier: FriendTableViewCell.identifier)
        cell.avatarImage.image = UIImage(named: "avatar")!.imageResize(sizeChange: CGSize(width: 50, height: 50))
        cell.nameLabel.text = "Najib Bukele"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
}
