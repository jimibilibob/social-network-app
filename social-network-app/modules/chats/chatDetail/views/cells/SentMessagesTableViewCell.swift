//
//  SentMessagesTableViewCell.swift
//  social-network-app
//
//  Created by user on 10/7/22.
//

import UIKit

class SentMessagesTableViewCell: UITableViewCell {
    
    
    @IBOutlet var messageButton: UIButton!
    static let identifier = "SentMessagesTableViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
    }
    
    func setupViews() {
        
        backgroundColor = UIColor(named: "backgroundLight")
        selectionStyle = .none
        let font = UIFont.systemFont(ofSize: 16.0)
        // TODO: pass a object containing the text message
        //let textwidth = messageButton.titleLabel?.text?.sizeOfString(font: font)
        let textwidth = "Sap Brow how u doing?".sizeOfString(font: font)
        messageButton.frame = CGRect(x: 0.0, y: 0.0, width: textwidth.width + 20, height: 40)
        messageButton.backgroundColor = .white
        messageButton.roundCorners(corners: [.topLeft, .topRight, .bottomRight], radius: 25)
    }
    
    
}

