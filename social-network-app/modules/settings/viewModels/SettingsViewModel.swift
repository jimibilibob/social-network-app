//
//  SettingsViewModel.swift
//  social-network-app
//
//  Created by user on 12/7/22.
//

import Foundation
import UIKit

class SettingsViewModel {
    let firebaseManager = FirebaseManager.shared
    let fireStoreManager = FirebaseStorageManager.shared
    var avatarData: Data?
    private let storageRoute = "avatars"

    var user : User?
    
    init() {
    }

    func getUser(completion: @escaping ( Result<User, Error>) -> Void) {
        firebaseManager.getDocuments(type: User.self, forCollection: .users) { result in
            switch result {
            case .success(let users):
                guard let user = users.first else { return completion(.failure(FirebaseErrors.InvalidUser)) }
                completion(.success(user))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func uploadPostFile(file: UIImage, completion: @escaping (URL) -> Void) {
        fireStoreManager.uploadPhoto(file: file, route: storageRoute) { fileUrl in
            completion(fileUrl)
        }
    }
    
    
    func editUser(user: User, completion: @escaping (User) -> Void) {
        firebaseManager.updateDocument(document: user, collection: .users) { result in
            switch result {
            case .success(let user):
                completion(user)
            case .failure(let error):
                print("Error", error)
            }
        }
    }

}
