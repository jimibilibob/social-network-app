//
//  RecievedMessageTableViewCell.swift
//  social-network-app
//
//  Created by user on 10/7/22.
//

import UIKit

class RecievedMessageTableViewCell: UITableViewCell {
    
    static var identifier = "RecievedMessageTableViewCell"
    
    @IBOutlet var mainBackground: UIView!
    @IBOutlet var messageLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }
    
    func setupViews() {
        backgroundColor = UIColor(named: "backgroundLight")
        selectionStyle = .none
        mainBackground.backgroundColor = .white
        mainBackground.roundCornersTwo(maskedCorners: [.layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMaxXMinYCorner], cornerRadius: 25)
        mainBackground.clipsToBounds = true
        messageLabel.sizeToFit()
    }
    
    /**
     func setupViews() {
         backgroundColor = UIColor(named: "backgroundLight")
         selectionStyle = .none
         mainBackgroundView.backgroundColor = .white
         mainBackgroundView.roundCornersTwo(maskedCorners: [.layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMaxXMinYCorner], cornerRadius: 25)
         mainBackgroundView.clipsToBounds = true
         messageLabel.sizeToFit()
     }
     */
}
