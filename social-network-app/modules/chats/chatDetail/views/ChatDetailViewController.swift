//
//  ChatDetailViewController.swift
//  social-network-app
//
//  Created by user on 10/7/22.
//

import UIKit

class ChatDetailViewController: UIViewController {

    @IBOutlet var mainViewBackground: UIView!
    @IBOutlet var closeButton: UIButton!
    @IBOutlet var avatarImage: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupTableView()
    }
    
    func setupViews() {
        avatarImage.image = UIImage(named: "avatar")!.imageResize(sizeChange: CGSize(width: 50, height: 50))
        mainViewBackground.backgroundColor = UIColor(named: "backgroundLight")
        mainViewBackground.layer.cornerRadius = 25
    }
    
    func setupTableView() {
        tableView.backgroundColor = UIColor(named: "backgroundLight")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: SentMessagesTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: SentMessagesTableViewCell.identifier)
        tableView.register(UINib(nibName: RecievedMessageTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: RecievedMessageTableViewCell.identifier)
    }
}


extension ChatDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row % 2 == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: SentMessagesTableViewCell.identifier, for: indexPath) as? SentMessagesTableViewCell ?? SentMessagesTableViewCell(style: .default, reuseIdentifier: SentMessagesTableViewCell.identifier)
            cell.messageButton.setTitle("Sap Brow how u doing?", for: .normal)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: RecievedMessageTableViewCell.identifier, for: indexPath) as? RecievedMessageTableViewCell ?? RecievedMessageTableViewCell(style: .default, reuseIdentifier: RecievedMessageTableViewCell.identifier)
            cell.messageButton.setTitle("Long time no c u", for: .normal)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }
}
