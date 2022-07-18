//
//  AuthFirebaseManager.swift
//  social-network-app
//
//  Created by user on 1/7/22.
//

import Foundation
import FirebaseFirestore

class AuthFirebaseManager {
    static let shared = AuthFirebaseManager()
    
    func login(userName: String, password: String, completion: @escaping ( Result<User, Error>) -> Void) {
        Firestore.firestore().collection(FirebaseCollections.users.rawValue)
            .whereField("userName", isEqualTo: userName)
            .whereField("password", isEqualTo: password)
            .getDocuments { querySnapshot, error in
                guard error == nil else { return completion(.failure(error!)) }
                guard let documents = querySnapshot?.documents, !documents.isEmpty
                       else { return completion(.failure(FirebaseErrors.InvalidUser)) }
                
                var items = [User]()
                let json = JSONDecoder()
                for document in documents {
                    if let data = try? JSONSerialization.data(withJSONObject: document.data(), options: []),
                       let item = try? json.decode(User.self, from: data) {
                        items.append(item)
                    }
                }
                guard let user = items.first else { return completion(.failure(FirebaseErrors.InvalidUser)) }
                completion(.success(user))
        }
    }

    func signUp(userName: String, password: String, completion: @escaping ( Result<User, Error>) -> Void) {
        let user = User(id: UUID().uuidString, name: userName, age: 0, email: "", password: password, updatedAt: Date(), createdAt: Date())
        
        FirebaseManager.shared.addDocument(document: user, collection: .users) { result in
            switch result {
            case .success(let user):
                print("Success", user)
                completion(.success(user))
            case .failure(let error):
                completion(.failure(error))
                print("Error", error)
            }
        }
    }
    
}
