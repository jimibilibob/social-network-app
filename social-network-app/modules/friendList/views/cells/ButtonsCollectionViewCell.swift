//
//  ButtonsCollectionViewCell.swift
//  social-network-app
//
//  Created by user on 1/8/22.
//

import UIKit

class ButtonsCollectionViewCell: UICollectionViewCell {

    static let identifier = "ButtonsCollectionViewCell"

    @IBOutlet var image: UIImageView!

    var delegate: ButtonsCollectionViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setupButtons(buttonType: FriendsButtonsType) {
        switch buttonType {
        case .accept:
            image.image = UIImage(systemName: "checkmark")
            let tap = UITapGestureRecognizer(target: self, action: #selector(didTapOnAcceptFriend))
            image.addGestureRecognizer(tap)
        case .add:
            image.image = UIImage(systemName: "person.fill.badge.plus")
            let tap = UITapGestureRecognizer(target: self, action: #selector(didTapOnAddFriend))
            image.addGestureRecognizer(tap)
        case .remove:
            image.image = UIImage(systemName: "xmark")?.withTintColor(.red, renderingMode: .alwaysOriginal)
            let tap = UITapGestureRecognizer(target: self, action: #selector(didTapOnRemoveFriend))
            image.addGestureRecognizer(tap)
        }
        image.isUserInteractionEnabled = true
    }

    @objc func didTapOnAddFriend() {
        delegate?.addFriend()
    }

    @objc func didTapOnAcceptFriend() {
        delegate?.acceptFriend()
    }

    @objc func didTapOnRemoveFriend() {
        delegate?.removeFriend()
    }
    
}

protocol ButtonsCollectionViewCellDelegate: AnyObject {
    func removeFriend()
    func addFriend()
    func acceptFriend()
}
