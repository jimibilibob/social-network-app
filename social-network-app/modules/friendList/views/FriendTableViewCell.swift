//
//  FrieldTableViewCell.swift
//  social-network-app
//
//  Created by user on 7/7/22.
//

import UIKit
import Kingfisher

class FriendTableViewCell: UITableViewCell {
    @IBOutlet var buttonsCollectionView: UICollectionView!
    static let identifier = "FriendTableViewCell"
    var buttons = [FriendsButtonsType]()

    var delegate: FriendTableViewCellDelegate?

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avatarImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setupViews(friend: Friend?, person: User?) {
        guard let person = person else { return }
        let imageProcessor = DownsamplingImageProcessor(size: avatarImage.bounds.size)
        avatarImage.kf.indicatorType = .activity
        avatarImage.kf.setImage(
            with: URL(string: person.avatar),
            placeholder: UIImage(named: "placeholderImage"),
            options: [
                .processor(imageProcessor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ]
        )
        avatarImage.contentMode = .scaleAspectFill
        avatarImage.layer.cornerRadius = 25
        nameLabel.text = person.name

        setupButtons(friend: friend)
    }

    private func setupButtons(friend: Friend?) {
        buttons = []
        let uiNib = UINib(nibName: ButtonsCollectionViewCell.identifier, bundle: nil)
        buttonsCollectionView.register(uiNib, forCellWithReuseIdentifier: ButtonsCollectionViewCell.identifier)

        buttonsCollectionView.delegate = self
        buttonsCollectionView.dataSource = self

        if let friend = friend, friend.friendState == FriendState.accepted.rawValue {
            return
        }
        if let friend = friend, friend.friendState == FriendState.pending.rawValue {
            let currentUser = DefaultsManager.shared.readUser()
            buttons.append(.remove)
            if friend.receiverUserId == currentUser.id {
                buttons.append(.accept)
            }
            return
        }
        buttons.append(.add)
    }
}

extension FriendTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return buttons.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ButtonsCollectionViewCell.identifier, for: indexPath) as? ButtonsCollectionViewCell ?? ButtonsCollectionViewCell()
        let buttonType = buttons[indexPath.row]
        cell.setupButtons(buttonType: buttonType)
        cell.delegate = self
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = 60
        let width = 60
        return CGSize(width: width, height: height)
    }
}

extension FriendTableViewCell: ButtonsCollectionViewCellDelegate {
    
    func removeFriend() {
        delegate?.removeFriend(cell: self)
    }
    
    func acceptFriend() {
        delegate?.acceptFriend(cell: self)
    }
    
    func addFriend() {
        delegate?.addFriend(cell: self)
    }
}

protocol FriendTableViewCellDelegate: AnyObject {
    func addFriend(cell: FriendTableViewCell)
    func removeFriend(cell: FriendTableViewCell)
    func acceptFriend(cell: FriendTableViewCell)
}
