//
//  Chat.swift
//  social-network-app
//
//  Created by user on 12/7/22.
//

import Foundation

struct Chat: Codable, BaseModel {
    var id: String
    let message: [String]
    var updatedAt: Date
    var createdAt: Date
}
