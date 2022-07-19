//
//  PostTableViewCell.swift
//  social-network-app
//
//  Created by user on 6/7/22.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet var commentLabel: UILabel!
    @IBOutlet var commentButton: UIButton!
    @IBOutlet var reactionLabel: UILabel!
    @IBOutlet var reactionButton: UIButton!
    @IBOutlet var mainBackground: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var postImage: UIImageView!
    static let identifier = "PostTableViewCell"

    var delegate: PostTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupViews()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupViews() {
        mainBackground.backgroundColor = UIColor(named: "backgroundLight")
        mainBackground.layer.cornerRadius = 25
        selectionStyle = .none
        bottomView.layer.cornerRadius = 25
        avatarImage.contentMode = .scaleAspectFit
        postImage.contentMode = .scaleToFill
        avatarImage.layer.cornerRadius = 25
        postImage.layer.cornerRadius = 25
    }

    func setUpReactionSection(hasReacted: Bool) {
        reactionButton.tintColor = hasReacted ? .red : .white
        reactionLabel.textColor = hasReacted ? .red : .white
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
    }

    @IBAction func reactionAction(_ sender: Any) {
        delegate?.react(cell: self)
    }
}

protocol PostTableViewCellDelegate: AnyObject {
    func react(cell: PostTableViewCell)
}
