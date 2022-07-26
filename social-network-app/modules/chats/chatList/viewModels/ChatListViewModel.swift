//
//  ChatListViewModel.swift
//  social-network-app
//
//  Created by user on 24/7/22.
//

import Foundation
import FirebaseFirestore

class ChatListViewModel {
    let firebaseManager = FirebaseManager.shared
    let fireStoreManager = FirebaseStorageManager.shared

    var chats = [Chat]()

    
    init() {
        self.listenChatChanges { chats in
            self.chats = chats
        }
        
    }

    func getAllChats(completion: @escaping ([Chat]) -> Void) {
        let user = DefaultsManager.shared.readUser()
        firebaseManager.getDocuments(type: Chat.self, forCollection: .chats) {
            result in
               switch result {
               case .success(var chats):
                   chats = chats.filter({ $0.participants.contains(where: { $0.userId == user.id }) })
                   completion(chats)
               case .failure(let error):
                   print("Error on listening posts \(error)")
               }
        }
    }
    
    func listenChatChanges(completion: @escaping ([Chat]) -> Void) {
        let user = DefaultsManager.shared.readUser()
        firebaseManager.listenCollectionChanges(type: Chat.self, collection: .chats) { result in
            switch result {
            case .success(var chats):
                chats = chats.filter({ $0.participants.contains(where: { $0.userId == user.id }) })
                completion(chats)
            case .failure(let error):
                print("Error on listening chats \(error)")
            }
        }
    }
    
    func addNewChat(participants: [Person], completion: @escaping (Result<Chat, Error>) -> Void) {
        let newChat = Chat(id: UUID().uuidString, participants: participants, updatedAt: Date(), createdAt: Date())
        self.firebaseManager.addDocument(document: newChat, collection: .chats, completion: { result in
            switch result {
            case .success(let chats):
                completion(.success(chats))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
    
    func removeChat(chatId: String, completion: @escaping (Result<String, Error>) -> Void) {
        firebaseManager.removeDocument(documentID: chatId, collection: .chats) { result in
            switch result {
            case .success(let chat):
                completion(.success(chat))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
