//
//  ChatDetailViewController.swift
//  social-network-app
//
//  Created by user on 10/7/22.
//

import UIKit

class ChatDetailViewController: UIViewController {
    

    @IBOutlet var messageTextField: UITextField!
    @IBOutlet var mainViewBackground: UIView!
    @IBOutlet var avatarImage: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "German Torook"
        setupViews()
        setupTableView()
    }
    
    @IBAction func closeAction(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    func setupViews() {
        let sendButton = UIButton()
        let image = UIImage(named: "send-button")!
        sendButton.setImage(image, for: .normal)
        sendButton.contentEdgeInsets =  UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 12)
        messageTextField.rightView = sendButton;
        messageTextField.rightViewMode = .always
        
        avatarImage.image = UIImage(named: "avatar")!.imageResize(sizeChange: CGSize(width: 50, height: 50))
        mainViewBackground.backgroundColor = UIColor(named: "backgroundLight")
        mainViewBackground.layer.cornerRadius = 25
        messageTextField.roundCornersTwo(maskedCorners: [.layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner], cornerRadius: 25)
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
            cell.messageLabel.text = "Sap Brow how u doing? Sap Brow how u doing?, Sap Brow how u doing?, Sap Brow how u doing?"
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: RecievedMessageTableViewCell.identifier, for: indexPath) as? RecievedMessageTableViewCell ?? RecievedMessageTableViewCell(style: .default, reuseIdentifier: RecievedMessageTableViewCell.identifier)
            cell.messageLabel.text = "Long time no c u, Sap Brow how u doing?, Sap Brow how u doing?, Sap Brow how u doing?, Sap Brow how u doing?, Sap Brow how u doing?, Sap Brow how u doing?, Sap Brow how u doing?, Sap Brow how u doing?, Sap Brow how u doing?"
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
