//
//  Post.swift
//  social-network-app
//
//  Created by user on 12/7/22.
//

import Foundation

struct Post: Codable, BaseModel {
    var id: String
    let photo: String
    let description: String
    let ownerId: String
    var updatedAt: Date
    var createdAt: Date
}
