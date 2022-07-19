//
//  Reactions.swift
//  social-network-app
//
//  Created by user on 19/7/22.
//

import Foundation

struct Reaction: Codable, BaseModel {
    var id: String
    let postId: String
    let ownerId: String
    var updatedAt: Date
    var createdAt: Date
}

