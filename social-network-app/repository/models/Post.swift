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
}
