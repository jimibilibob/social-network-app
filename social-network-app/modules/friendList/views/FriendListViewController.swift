//
//  FriendListViewController.swift
//  social-network-app
//
//  Created by user on 7/7/22.
//

import UIKit
import Kingfisher

class FriendListViewController: UIViewController {
    lazy var viewModel = {
        FriendsListViewModel()
    }()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        loadFriends()
    }
    
    func setupTableView() {
        title = "Friends"
        tableView.delegate = self
        tableView.dataSource = self
        viewModel.reloadTable = tableView.reloadData
        
        tableView.register(UINib(nibName: FriendTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: FriendTableViewCell.identifier)
    }

    func loadFriends() {
        viewModel.getAllFriends() { result in
            switch result {
            case .success(let friends):
                self.viewModel.friends = friends
                self.viewModel.getPeopleData() { people in
                        self.viewModel.people = people
                    self.tableView.reloadData()
                }
            case .failure(_):
                ErrorAlert.shared.showAlert(title: "Error", target: self)
            }
        }
    }
}

extension FriendListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FriendTableViewCell.identifier, for: indexPath) as? FriendTableViewCell ?? FriendTableViewCell(style: .default, reuseIdentifier: FriendTableViewCell.identifier)

        let personData = self.viewModel.people[indexPath.row]
        let friend = self.viewModel.getFriend(person: personData)

        cell.setupViews(friend: friend, person: personData)
        cell.delegate = self
        cell.buttonsCollectionView.reloadData()
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let person = self.viewModel.people[indexPath.row]
        let vc = ProfileViewController(user: person)
        show(vc, sender: nil)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
}

extension FriendListViewController: FriendTableViewCellDelegate {
    func addFriend(cell: FriendTableViewCell) {
        guard let indexPath = self.tableView.indexPath(for: cell) else { return }
        let person = self.viewModel.people[indexPath.row]
        let friend = self.viewModel.getFriendByPerson(person: person)
        self.viewModel.addNewFriend(friend: friend) { result in
            switch result {
            case .success(_):
                self.tableView.reloadData()
            case .failure(_):
                ErrorAlert.shared.showAlert(title: "Error", target: self)
            }
        }
    }

    func acceptFriend(cell: FriendTableViewCell) {
        guard let indexPath = self.tableView.indexPath(for: cell) else { return }
        let person = self.viewModel.people[indexPath.row]
        let friend = self.viewModel.getFriend(person: person)
        guard let friend = friend else { return }
        self.viewModel.acceptFriend(friend: friend) { result in
            switch result {
            case .success(_):
                self.tableView.reloadData()
            case .failure(_):
                ErrorAlert.shared.showAlert(title: "Error", target: self)
            }
        }
    }

    func removeFriend(cell: FriendTableViewCell) {
        guard let indexPath = self.tableView.indexPath(for: cell) else { return }
        let person = self.viewModel.people[indexPath.row]
        let friend = self.viewModel.getFriend(person: person)
        guard let friend = friend else { return }
        self.viewModel.removeFriend(friendId: friend.id) { result in
            switch result {
            case .success(_):
                self.tableView.reloadData()
            case .failure(_):
                ErrorAlert.shared.showAlert(title: "Error", target: self)
            }
        }
    }
}
