//
//  Friend.swift
//  social-network-app
//
//  Created by user on 31/7/22.
//

import Foundation

struct Friend: Codable, BaseModel {
    var id: String
    let senderUserId: String
    let receiverUserId: String
    let friendState: String
    var updatedAt: Date
    var createdAt: Date
}

enum FriendState: String {
    case pending, accepted
}

enum FriendsButtonsType {
    case accept, remove, add
}
