//
//  RecievedMessageTableViewCell.swift
//  social-network-app
//
//  Created by user on 10/7/22.
//

import UIKit

class RecievedMessageTableViewCell: UITableViewCell {
    
    static var identifier = "RecievedMessageTableViewCell"
    
    @IBOutlet var messageButton: UIButton!
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
        let textwidth = "Lonjsj sj time no c u".sizeOfString(font: font)
        messageButton.frame = CGRect(x: 0.0, y: 0.0, width: textwidth.width + 20, height: 40)
        messageButton.roundCorners(corners: [.bottomLeft, .topLeft, .topRight], radius: 25)
    }
}
