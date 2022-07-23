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
    
    func setupViews() {
        backgroundColor = UIColor(named: "backgroundLight")
        selectionStyle = .none
        let leadingMargin: CGFloat = 10
        let trailingMargin: CGFloat = 10

        let style = NSMutableParagraphStyle()
        style.alignment = .justified
        style.firstLineHeadIndent = leadingMargin
        style.headIndent = leadingMargin
        style.tailIndent = trailingMargin
        mainBackground.backgroundColor = messageLabel.backgroundColor
        mainBackground.layer.cornerRadius = 15
        mainBackground.clipsToBounds = true
        //messageLabel.sizeToFit()
    }
}
