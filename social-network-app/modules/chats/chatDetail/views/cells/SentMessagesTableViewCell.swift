//
//  SentMessagesTableViewCell.swift
//  social-network-app
//
//  Created by user on 10/7/22.
//

import UIKit

class SentMessagesTableViewCell: UITableViewCell {
    
    @IBOutlet var mainBackgroundView: UIView!
    @IBOutlet var messageLabel: UILabel!
    
    static let identifier = "SentMessagesTableViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupViews() {
        backgroundColor = UIColor(named: "backgroundLight")
        selectionStyle = .none
        mainBackgroundView.backgroundColor = .white
        mainBackgroundView.roundCornersTwo(maskedCorners: [.layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMaxXMinYCorner], cornerRadius: 25)
        mainBackgroundView.clipsToBounds = true
        messageLabel.sizeToFit()
    }
    
    
}

