//
//  SettingsViewModel.swift
//  social-network-app
//
//  Created by user on 12/7/22.
//

import Foundation

class SettingsViewModel {
    let firebaseManager = FirebaseManager.shared

    var user : User?
    
    init(user: User) {
        self.user = user
    }
}
