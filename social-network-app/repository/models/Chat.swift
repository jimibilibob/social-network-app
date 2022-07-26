//
//  Chat.swift
//  social-network-app
//
//  Created by user on 12/7/22.
//

import Foundation

struct Chat: Codable, BaseModel {
    var id: String
    let participants: [Person]
    var updatedAt: Date
    var createdAt: Date
}

struct Message: Codable, BaseModel {
    var id: String
    let message: String
    let senderId: String
    let chatId: String
    var updatedAt: Date
    var createdAt: Date
}
