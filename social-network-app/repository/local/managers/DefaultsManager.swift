//
//  DefaultsManager.swift
//  social-network-app
//
//  Created by user on 20/7/22.
//

import Foundation

class DefaultsManager {
    static let shared = DefaultsManager()
    private let defaults = UserDefaults.standard
    private let userKey = "userKey"
    
    func storeUser(user: User) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(user)
            defaults.set(data, forKey: userKey)
        } catch {
            print("Unable to Encode User \(user)")
        }
    }

    func readUser() -> User {
        var user = User(id: "", name: "", age: 0, email: "", avatar: "", password: "", updatedAt: Date(), createdAt: Date())
        if let data = defaults.data(forKey: userKey) {
            do {
                let decoder = JSONDecoder()
                user = try decoder.decode(User.self, from: data)
                return user
            } catch {
                return user
            }
        }
        return user
    }
}

