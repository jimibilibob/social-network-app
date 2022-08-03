//
//  ChatDetailViewModel.swift
//  social-network-app
//
//  Created by user on 12/7/22.
//

import Foundation

class ChatDetailViewModel {
    let firebaseManager = FirebaseManager.shared
    let fireStoreManager = FirebaseStorageManager.shared

    var messages = [Message]()
    var reloadTable: (() -> Void)?
    var scrollToBotton: (() -> Void)?

    var chat: Chat
    
    init(chat: Chat) {
        self.chat = chat
        self.listenMessageChanges { messages in
            self.messages = messages
            self.reloadTable?()
            if !messages.isEmpty {
                self.scrollToBotton?()
            }
        }
        
    }

    func getAllMessages(completion: @escaping ( Result<[Message], Error>) -> Void) {
        firebaseManager.getDocuments(by: ["chatId": chat.id], type: Message.self, forCollection: .messages) { result in
            switch result {
            case .success(var messages):
                messages = messages.sorted(by: {$0.createdAt < $1.createdAt})
                completion(.success(messages))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func listenMessageChanges(completion: @escaping ([Message]) -> Void) {
        firebaseManager.listenCollectionChanges(by: ["chatId": chat.id], type: Message.self, collection: .messages) { result in
            switch result {
            case .success(var messages):
                messages = messages.sorted(by: {$0.createdAt < $1.createdAt})
                completion(messages)
            case .failure(let error):
                print("Error on listening messages \(error)")
            }
        }
    }
    
    func addNewMessage(message: String, completion: @escaping (Result<Message, Error>) -> Void) {
        let newMessage = Message(id: UUID().uuidString, message: message, senderId: DefaultsManager.shared.readUser().id, chatId: chat.id, updatedAt: Date(), createdAt: Date())
        self.firebaseManager.addDocument(document: newMessage, collection: .messages, completion: { result in
            switch result {
            case .success(let messages):
                completion(.success(messages))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
    
    func removeMessage(messageId: String, completion: @escaping (Result<String, Error>) -> Void) {
        firebaseManager.removeDocument(documentID: messageId, collection: .messages) { result in
            switch result {
            case .success(let message):
                completion(.success(message))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

}
