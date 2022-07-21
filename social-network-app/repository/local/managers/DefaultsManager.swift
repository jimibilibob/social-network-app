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
    private let userIdKey = "userIdKey"
    
    func storeUserId(value: String, completion: @escaping () -> Void) {
        defaults.set(value, forKey: userIdKey)
        completion()
    }

    func readUserId() -> String {
        return defaults.string(forKey: userIdKey) ?? ""
    }
}

