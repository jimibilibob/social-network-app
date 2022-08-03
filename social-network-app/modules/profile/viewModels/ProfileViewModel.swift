//
//  ProfileViewModel.swift
//  social-network-app
//
//  Created by user on 12/7/22.
//

import Foundation
import UIKit

class ProfileViewModel {
    let firebaseManager = FirebaseManager.shared
    let fireStoreManager = FirebaseStorageManager.shared
    let storageRoute = "posts"

    var reloadTable: (()->Void)?

    var posts = [Post]()
    var postData: Data?

    var reactions = [Reaction]()
    
    init(user: User) {
        self.listenPostChanges(user: user) { posts in
            self.posts = posts
            self.reloadTable?()
            self.listenReactionsChanges(posts: posts) { reactions in
                self.reactions = reactions
                self.reloadTable?()
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
    
    func listenPostChanges(user: User, completion: @escaping ([Post]) -> Void) {
        firebaseManager.listenCollectionChanges(whereIn: ["ownerId": [user.id]], type: Post.self, collection: .posts) { result in
            switch result {
            case .success(let posts):
                completion(posts)
            case .failure(let error):
                print("Error on listening posts \(error)")
            }
        }
    }

    func listenReactionsChanges(posts: [Post], completion: @escaping ([Reaction]) -> Void) {
        guard !posts.isEmpty else { return completion([]) }
        let postsIds = posts.map({ $0.id })
        firebaseManager.listenCollectionChanges(whereIn: ["postId": postsIds], type: Reaction.self, collection: .reactions) { result in
            switch result {
            case .success(let reactions):
                completion(reactions)
            case .failure(let error):
                print("Error on listening posts \(error)")
            }
        }
    }
    
    func addNewPost(post: Post, completion: @escaping (Result<Post, Error>) -> Void) {
        self.firebaseManager.addDocument(document: post, collection: .posts, completion: { result in
            switch result {
            case .success(let post):
                completion(.success(post))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }

    func uploadPostFile(file: UIImage, completion: @escaping (URL) -> Void) {
        fireStoreManager.uploadPhoto(file: file, route: storageRoute) { fileUrl in
            completion(fileUrl)
        }
    }
    
    
    func editPost(post: Post, completion: @escaping (Post) -> Void) {
        firebaseManager.updateDocument(document: post, collection: .posts) { result in
            switch result {
            case .success(let post):
                completion(post)
            case .failure(let error):
                print("Error", error)
            }
        }
    }
    
    
    func removePost(postId: String, completion: @escaping (Result<String, Error>) -> Void) {
        firebaseManager.removeDocument(documentID: postId, collection: .posts) { result in
            switch result {
            case .success(let message):
                completion(.success(message))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func addReaction(reaction: Reaction) {
        self.firebaseManager.addDocument(document: reaction, collection: .reactions, completion: { result in
            switch result {
            case .success(let reaction):
                print("Added reaction \(reaction)")
            case .failure(let error):
                print("Error while add reaction \(error)")
            }
        })
    }

    func removeReaction(reactionId: String) {
        firebaseManager.removeDocument(documentID: reactionId, collection: .reactions){ result in
            switch result {
            case .success(let reaction):
                print("Removed reaction \(reaction)")
            case .failure(let error):
                print("Error while remove reaction \(error)")
            }
        }
    }

    func hasReacted(userId: String, post: Post) -> Bool {
        guard !reactions.isEmpty else { return false }
        return !reactions.filter({ $0.postId == post.id && $0.ownerId == userId }).isEmpty
    }

    func reactionCount(post: Post) -> Int {
        guard !reactions.isEmpty else { return 0 }
        return reactions.filter({ $0.postId == post.id}).count
    }

    // MARK: Add Chat if neccesary
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

    func getChatIfExists(user: User, participants: [Person], completion: @escaping (Chat?) -> Void) {
        getAllChats(user: user) { chats in
            var oldChat: Chat? = nil
            for chat in chats {
                if chat.participants.containsSameElements(as: participants) {
                    oldChat = chat
                    break
                }
            }
            completion(oldChat)
        }
    }

    private func getAllChats(user: User, completion: @escaping ([Chat]) -> Void) {
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

    // MARK: Friends
    func getAllAcceptedFriends(user: User, completion: @escaping ([Friend]) -> Void) {
        firebaseManager.getDocuments(type: Friend.self, forCollection: .friends) { result in
            switch result {
            case .success(var friends):
                friends = friends.filter({ ($0.receiverUserId ==  user.id ||                    $0.senderUserId == user.id) &&
                    $0.friendState == FriendState.accepted.rawValue
                })
                completion(friends)
            case .failure(let error):
                print("Error while getting accepted Friends", error.localizedDescription)
            }
        }
    }
}
