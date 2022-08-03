//
//  ChatDetailViewController.swift
//  social-network-app
//
//  Created by user on 10/7/22.
//

import UIKit
import Kingfisher

class ChatDetailViewController: UIViewController {
    var chat: Chat

    lazy var viewModel = {
        ChatDetailViewModel(chat: self.chat)
    }()

    let sendButton = UIButton()
    @IBOutlet var messageTextField: UITextField!
    @IBOutlet var mainViewBackground: UIView!
    @IBOutlet var avatarImage: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    
    init(chat: Chat) {
        self.chat = chat
        super.init(nibName: nil, bundle: nil)
        self.viewModel.chat = chat
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupTableView()
        setupTextField()
        loadMessages()
    }
    
    @IBAction func closeAction(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }

    func setupViews() {
        // Catching user photo, just considering two Participants
        let participant = chat.participants.filter({ $0.userId != DefaultsManager.shared.readUser().id })[0]
        title = participant.name
        let url = URL(string: participant.photo)
        let processor = DownsamplingImageProcessor(size: avatarImage.bounds.size)
                     |> RoundCornerImageProcessor(cornerRadius: 25)
        avatarImage.kf.indicatorType = .activity
        avatarImage.kf.setImage(
            with: url,
            placeholder: UIImage(named: "placeholderImage"),
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ]
        )
        nameLabel.text = participant.name
        mainViewBackground.backgroundColor = UIColor(named: "backgroundLight")
        mainViewBackground.layer.cornerRadius = 25
    }

    func setupTextField() {
        let image = UIImage(named: "send-button")
        sendButton.setImage(image, for: .normal)
        sendButton.contentEdgeInsets =  UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 12)
        let tap = UITapGestureRecognizer(target: self, action: #selector(sendAction))
        sendButton.addGestureRecognizer(tap)
        messageTextField.rightView = sendButton;
        messageTextField.rightViewMode = .always
        messageTextField.roundCornersTwo(maskedCorners: [.layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner], cornerRadius: 25)
    }

    @objc func sendAction(_ sender: UITapGestureRecognizer) {
        guard let text = self.messageTextField.text,
              !text.isEmpty else { return }
        self.messageTextField.text = ""
        viewModel.addNewMessage(message: text) { result in
            switch result {
            case .success(let message):
                print("Added new message \(message)")
                self.viewModel.getAllMessages { result in
                    switch result {
                    case .success(let messages):
                        self.viewModel.messages = messages
                        self.tableView.reloadData()
                    case .failure(let error):
                        print("Error: \(error)")
                    }
                }
            case .failure(let error):
                ErrorAlert.shared.showAlert(title: "Error while sending message", message: error.localizedDescription, target: self)
            }
        }
    }

    func setupTableView() {
        tableView.backgroundColor = UIColor(named: "backgroundLight")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: SentMessagesTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: SentMessagesTableViewCell.identifier)
        tableView.register(UINib(nibName: RecievedMessageTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: RecievedMessageTableViewCell.identifier)
        self.viewModel.reloadTable = self.tableView.reloadData
        viewModel.scrollToBotton = tableView.scrollToBottom
    }

    func loadMessages() {
        viewModel.chat = self.chat
        viewModel.getAllMessages { result in
            switch result {
            case .success(let messages):
                self.viewModel.messages = messages
                self.tableView.reloadData()
            case .failure(let error):
                ErrorAlert.shared.showAlert(title: "Error while fetching messages", message: error.localizedDescription, target: self)
            }
        }
    }
}


extension ChatDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = viewModel.messages[indexPath.row]
        if message.senderId == DefaultsManager.shared.readUser().id {
            let cell = tableView.dequeueReusableCell(withIdentifier: SentMessagesTableViewCell.identifier, for: indexPath) as? SentMessagesTableViewCell ?? SentMessagesTableViewCell(style: .default, reuseIdentifier: SentMessagesTableViewCell.identifier)
            cell.messageLabel.text = message.message
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: RecievedMessageTableViewCell.identifier, for: indexPath) as? RecievedMessageTableViewCell ?? RecievedMessageTableViewCell(style: .default, reuseIdentifier: RecievedMessageTableViewCell.identifier)
            cell.messageLabel.text = message.message
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
