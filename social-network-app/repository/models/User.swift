//
//  User.swift
//  social-network-app
//
//  Created by user on 29/6/22.
//

import Foundation

struct User: Codable, BaseModel {
    var id: String
    let name: String
    let age: Int
}
