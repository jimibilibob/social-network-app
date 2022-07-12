//
//  PostTableViewModel.swift
//  social-network-app
//
//  Created by user on 12/7/22.
//

import Foundation

class PostTableViewModel {
    let firebaseManager = FirebaseManager.shared

    var posts = [Post]()
    
    init() {
        firebaseManager.listenCollectionChanges(type: Post.self, collection: .posts) { result in
            self.listenUserChanges(result: result)
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
    

    
    func addPost(post: Post) {
        
        firebaseManager.addDocument(document: post, collection: .posts) { result in
            switch result {
            case .success(let post):
                print("Success", post)
            case .failure(let error):
                print("Error", error)
            }
        }
    }

    
    
    func editUser(post: Post) {
        firebaseManager.updateDocument(document: post, collection: .posts) { result in
            switch result {
            case .success(let post):
                print("Success", post)
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
