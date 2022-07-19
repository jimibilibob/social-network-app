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
    var reloadTable: (() -> Void)?

    var posts = [Post]()
    var postData: Data?
    
    init() {
        firebaseManager.listenCollectionChanges(type: Post.self, collection: .posts) { result in
            self.listenUserChanges(result: result)
        }
    }
    
    func getAllPosts() {
        firebaseManager.getDocuments(type: Post.self, forCollection: .posts) { result in
            switch result {
            case .success(let posts):
                self.posts = posts
                self.reloadTable?()
            case .failure(let error):
                print("ERROR POSTS FETCH", error)
            }
        }
    }
    
    func listenUserChanges(result: Result<[Post], Error>) {
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
                print("Error Add Post \(error)")
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
    
    
    func removeUser(postId: String) {
        firebaseManager.removeDocument(documentID: postId, collection: .posts){ result in
            switch result {
            case .success(let post):
                print("Success", post)
            case .failure(let error):
                print("Error", error)
            }
        }
    }
}
