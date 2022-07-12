//
//  ChatDetailViewModel.swift
//  social-network-app
//
//  Created by user on 12/7/22.
//

import Foundation

class ChatDetailViewModel {
    let firebaseManager = FirebaseManager.shared

    var chat : Chat?
    
    init(chat: Chat) {
        self.chat = chat
    }
}
