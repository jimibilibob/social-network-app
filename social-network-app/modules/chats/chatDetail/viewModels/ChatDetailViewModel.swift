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

    var chat: Chat?
    
    init() {
        self.listenMessageChanges { messages in
            self.messages = messages
        }
        
    }
    
    func getAllPosts(completion: @escaping ( Result<[Post], Error>) -> Void) {
        firebaseManager.getDocuments(type: Post.self, forCollection: .posts) { result in
            switch result {
            case .success(let posts):
                completion(.success(posts))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func getAllPosts(by userId: String?, completion: @escaping ( Result<[Post], Error>) -> Void) {
        guard let userId = userId else { return }
        firebaseManager.getDocuments(by: ["ownerId": userId], type: Post.self, forCollection: .posts) { result in
            switch result {
            case .success(let posts):
                completion(.success(posts))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func getAllReactions(posts: [Post], completion: @escaping ( Result<[Reaction], Error>) -> Void) {
        guard !posts.isEmpty else { return completion(.success([])) }
        let postsIds = posts.map({ $0.id })
        firebaseManager.getDocuments(whereIn: ["postId": postsIds], type: Reaction.self, forCollection: .reactions) { result in
            switch result {
            case .success(let reactions):
                completion(.success(reactions))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func listenMessageChanges(completion: @escaping ([Message]) -> Void) {
        guard let chat = chat else { return }
        firebaseManager.listenCollectionChanges(whereIn: ["chatId": [chat.id]], type: Message.self, collection: .messages) { result in
            switch result {
            case .success(let messages):
                completion(messages)
            case .failure(let error):
                print("Error on listening messages \(error)")
            }
        }
    }
    
    func addNewMessage(message: String, completion: @escaping (Result<Message, Error>) -> Void) {
        guard let chat = chat else { return }
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
