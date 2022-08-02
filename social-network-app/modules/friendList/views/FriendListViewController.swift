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
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        loadFriends()
        setupSearchBar()
    }

    func setupSearchBar() {
        searchBar.delegate = self
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
                    self.tableView.reloadData()
                }
            case .failure(_):
                ErrorAlert.shared.showAlert(title: "Error", target: self)
            }
        }
    }
}

extension FriendListViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard searchText.isEmpty else { return }
        viewModel.filterPeople(word: searchText)
        searchBar.text = ""
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text,
                !searchText.isEmpty else { return }
        view.endEditing(true)
        viewModel.filterPeople(word: searchText)
        tableView.reloadData()
    }
}

extension FriendListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.filteredPeople.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FriendTableViewCell.identifier, for: indexPath) as? FriendTableViewCell ?? FriendTableViewCell(style: .default, reuseIdentifier: FriendTableViewCell.identifier)

        let personData = self.viewModel.filteredPeople[indexPath.row]
        let friend = self.viewModel.getFriend(person: personData)

        cell.setupViews(friend: friend, person: personData)
        cell.delegate = self
        cell.buttonsCollectionView.reloadData()
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let person = self.viewModel.filteredPeople[indexPath.row]
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
        let person = self.viewModel.filteredPeople[indexPath.row]
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
        let person = self.viewModel.filteredPeople[indexPath.row]
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
        let person = self.viewModel.filteredPeople[indexPath.row]
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
