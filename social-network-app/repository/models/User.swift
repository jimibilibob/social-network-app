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
    let email: String
    let avatar: String
    let password: String
    var updatedAt: Date
    var createdAt: Date
}

struct Person: Codable, BaseModel, Comparable {
    static func < (lhs: Person, rhs: Person) -> Bool {
        return lhs.userId < rhs.userId
    }

    static func == (lhs: Person, rhs: Person) -> Bool {
        return lhs.userId == rhs.userId
    }
    
    var id: String
    let userId: String
    let name: String
    let photo: String
    var updatedAt: Date
    var createdAt: Date
}
