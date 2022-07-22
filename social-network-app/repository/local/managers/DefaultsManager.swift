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

    func readUser() -> User? {
        if let data = defaults.data(forKey: userKey) {
            do {
                let decoder = JSONDecoder()
                let user = try decoder.decode(User.self, from: data)
                return user
            } catch {
                return nil
            }
        }
        return nil
    }
}

