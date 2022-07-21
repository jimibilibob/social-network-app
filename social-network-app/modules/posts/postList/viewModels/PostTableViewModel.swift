//
//  PostTableViewModel.swift
//  social-network-app
//
//  Created by user on 12/7/22.
//

import Foundation
import UIKit

class PostTableViewModel {
    let firebaseManager = FirebaseManager.shared
    let fireStoreManager = FirebaseStorageManager.shared
    let storageRoute = "posts"

    var posts = [Post]()
    var postData: Data?
    var selectedPost: Post?

    var reactions = [Reaction]()
    
    init() {
        firebaseManager.listenCollectionChanges(type: Post.self, collection: .posts) { result in
            self.listenPostChanges(result: result)
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

    func getAllPosts(by userId: String, completion: @escaping ( Result<[Post], Error>) -> Void) {
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
    
    func listenPostChanges(result: Result<[Post], Error>) {
        switch result {
        case .success(let posts):
            self.posts = posts
        case .failure(let error):
            print("Error", error)
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
}
