//
//  FirebaseManager.swift
//  social-network-app
//
//  Created by user on 29/6/22.
//

import Foundation
import FirebaseFirestore


enum FirebaseErrors: Error {
    case ErrorToDecodeItem
    case InvalidUser
    case InvalidQueries
}

enum FirebaseCollections: String {
    case users
    case posts
    case reactions
}

class FirebaseManager {
    static let shared = FirebaseManager()
    let db = Firestore.firestore()
    
    func getDocID(forCollection collection: FirebaseCollections) -> String {
        db.collection(collection.rawValue).document().documentID
    }
    
    func getDocuments<T: Decodable>(type: T.Type, forCollection collection: FirebaseCollections, completion: @escaping ( Result<[T], Error>) -> Void  ) {
        db.collection(collection.rawValue).order(by: "createdAt", descending: true).getDocuments { querySnapshot, error in
            guard error == nil else { return completion(.failure(error!)) }
            guard let documents = querySnapshot?.documents else { return completion(.success([])) }
            
            var items = [T]()
            let json = JSONDecoder()
            for document in documents {
                if let data = try? JSONSerialization.data(withJSONObject: document.data(), options: []),
                   let item = try? json.decode(type, from: data) {
                    items.append(item)
                }
            }
            completion(.success(items))
        }

    }

    func getDocuments<T: Decodable>(by parameters: [String: Any], type: T.Type, forCollection collection: FirebaseCollections, completion: @escaping ( Result<[T], Error>) -> Void  ) {
        let queries = getQuery(from: parameters, forCollection: collection)
        guard let q = queries else { return completion(.failure(FirebaseErrors.InvalidQueries)) }
        q.order(by: "createdAt", descending: true).getDocuments { querySnapshot, error in
            guard error == nil else { return completion(.failure(error!)) }
            guard let documents = querySnapshot?.documents else { return completion(.success([])) }
            
            var items = [T]()
            let json = JSONDecoder()
            for document in documents {
                if let data = try? JSONSerialization.data(withJSONObject: document.data(), options: []),
                   let item = try? json.decode(type, from: data) {
                    items.append(item)
                }
            }
            completion(.success(items))
        }

    }

    func getDocuments<T: Decodable>(whereIn: [String: [Any]], type: T.Type, forCollection collection: FirebaseCollections, completion: @escaping ( Result<[T], Error>) -> Void  ) {
        var q: Query = db.collection(collection.rawValue)
        if !whereIn.isEmpty {
            for (_, p) in whereIn.enumerated() {
                q = q.whereField(p.key, in: p.value)
            }
        }
        q.order(by: "createdAt", descending: true).getDocuments { querySnapshot, error in
            guard error == nil else { return completion(.failure(error!)) }
            guard let documents = querySnapshot?.documents else { return completion(.success([])) }
            
            var items = [T]()
            let json = JSONDecoder()
            for document in documents {
                if let data = try? JSONSerialization.data(withJSONObject: document.data(), options: []),
                   let item = try? json.decode(type, from: data) {
                    items.append(item)
                }
            }
            completion(.success(items))
        }

    }

    private func getQuery(from parameters: [String: Any], forCollection collection: FirebaseCollections) -> Query? {
        var q: Query?
        
        for (n, p) in parameters.enumerated() {
            if n == 0 {
                /* This is the first iteration of the loop
                 and so this is where we initialize the
                 query object using the first parameter. */
                q = db.collection(collection.rawValue).whereField(p.key, isEqualTo: p.value)
            } else {
                /* This is an additional iteration of the loop
                 and so this is where we append the existing
                 query object with the additional parameter. */
                q = q?.whereField(p.key, isEqualTo: p.value)
            }
        }
        
        return q
    }
    
    func listenCollectionChanges<T: Decodable>(type: T.Type, collection: FirebaseCollections, completion: @escaping ( Result<[T], Error>) -> Void  ) {
        db.collection(collection.rawValue).addSnapshotListener { querySnapshot, error in
            guard error == nil else { return completion(.failure(error!)) }
            guard let documents = querySnapshot?.documents else { return completion(.success([])) }
            
            
            var items = [T]()
            let json = JSONDecoder()
            for document in documents {
                if let data = try? JSONSerialization.data(withJSONObject: document.data(), options: []),
                   let item = try? json.decode(type, from: data) {
                    items.append(item)
                }
            }
            completion(.success(items))
        }
    }
    
    
    func addDocument<T: Encodable & BaseModel>(document: T, collection: FirebaseCollections, completion: @escaping ( Result<T, Error>) -> Void  ) {
        guard let itemDict = document.dict else { return completion(.failure(FirebaseErrors.ErrorToDecodeItem)) }
        
        db.collection(collection.rawValue).document(document.id).setData(itemDict) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(document))
            }
        }
        
    }

    
    
    func updateDocument<T: Encodable & BaseModel>(document: T, collection: FirebaseCollections, completion: @escaping ( Result<T, Error>) -> Void  ) {
        guard let itemDict = document.dict else { return completion(.failure(FirebaseErrors.ErrorToDecodeItem)) }
        
        db.collection(collection.rawValue).document(document.id).setData(itemDict) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(document))
            }
        }
    }
    
    
    func removeDocument(documentID: String, collection: FirebaseCollections, completion: @escaping ( Result<String, Error>) -> Void  ) {
        
        db.collection(collection.rawValue).document(documentID).delete() { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(documentID))
            }
        }
    }
    
    
    
    
}
