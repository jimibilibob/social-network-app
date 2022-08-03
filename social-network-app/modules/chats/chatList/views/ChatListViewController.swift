//
//  ChatListViewController.swift
//  social-network-app
//
//  Created by user on 7/7/22.
//

import UIKit
import Kingfisher

class ChatListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    lazy var viewModel = {
        ChatListViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        loadChats()
    }

    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: ChatTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ChatTableViewCell.identifier)

        viewModel.reloadTable = tableView.reloadData
    }

    func loadChats() {
        viewModel.getAllChats { chats in
            self.viewModel.chats = chats
            self.tableView.reloadData()
        }
    }
}

extension ChatListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.chats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChatTableViewCell.identifier, for: indexPath) as? ChatTableViewCell ?? ChatTableViewCell(style: .default, reuseIdentifier: ChatTableViewCell.identifier)
        
        let chat = viewModel.chats[indexPath.row]
        // Catching user photo, just considering two Participants
        let participant = chat.participants.filter({ $0.userId != DefaultsManager.shared.readUser().id })[0]
        let url = URL(string: participant.photo)
        let processor = DownsamplingImageProcessor(size: cell.avatarImage.bounds.size)
                     |> RoundCornerImageProcessor(cornerRadius: 25)
        cell.avatarImage.kf.indicatorType = .activity
        cell.avatarImage.kf.setImage(
            with: url,
            placeholder: UIImage(named: "placeholderImage"),
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ]
        )
        cell.nameLabel.text = participant.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chat = viewModel.chats[indexPath.row]
        let chatDetail = ChatDetailViewController(chat: chat)
        show(chatDetail, sender: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
}
