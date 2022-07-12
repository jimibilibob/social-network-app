//
//  FrieldTableViewCell.swift
//  social-network-app
//
//  Created by user on 7/7/22.
//

import UIKit

class FriendTableViewCell: UITableViewCell {
    
    static let identifier = "FriendTableViewCell"

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avatarImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
