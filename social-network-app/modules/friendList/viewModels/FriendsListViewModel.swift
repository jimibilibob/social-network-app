//
//  FriendsListViewModel.swift
//  social-network-app
//
//  Created by user on 31/7/22.
//

import Foundation

class FriendsListViewModel {
    let firebaseManager = FirebaseManager.shared
    let fireStoreManager = FirebaseStorageManager.shared

    var friends = [Friend]()
    var people = [User]()
    var reloadTable: (() -> Void)?
    var reloadCollectionView: (() -> Void)?
    
    init() {
        self.listenFriendsChanges { friends in
            self.friends = friends
            self.reloadTable?()
            self.reloadCollectionView?()
        }
        
    }

    func getAllFriends(completion: @escaping ( Result<[Friend], Error>) -> Void) {
        let currentUser = DefaultsManager.shared.readUser()
        firebaseManager.getDocuments(type: Friend.self, forCollection: .friends) { result in
            switch result {
            case .success(var friends):
                friends = friends.filter({ $0.receiverUserId ==  currentUser.id ||                    $0.senderUserId == currentUser.id})
                completion(.success(friends))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func listenFriendsChanges(completion: @escaping ([Friend]) -> Void) {
        let currentUser = DefaultsManager.shared.readUser()
        firebaseManager.listenCollectionChanges(type: Friend.self, collection: .friends) { result in
            switch result {
            case .success(var friends):
                friends = friends.filter({ $0.receiverUserId ==  currentUser.id ||                    $0.senderUserId == currentUser.id})
                completion(friends)
            case .failure(let error):
                print("Error on listening friends \(error)")
            }
        }
    }

    func getPeopleData(completion: @escaping ([User]) -> Void) {
        firebaseManager.getDocuments(type: User.self, forCollection: .users) { result in
            switch result {
            case .success(var people):
                people = people.filter({ $0.id != DefaultsManager.shared.readUser().id })
                self.people = people
                completion(people)
            case .failure(let error):
                print("Error while fetching people \(error)")
            }
        }
    }

    func addNewFriend(friend: Friend, completion: @escaping (Result<Friend, Error>) -> Void) {
        let friend = Friend(id: friend.id, senderUserId: friend.senderUserId, receiverUserId: friend.receiverUserId, friendState: FriendState.pending.rawValue, updatedAt: Date(), createdAt: friend.createdAt)
        self.firebaseManager.addDocument(document: friend, collection: .friends, completion: { result in
            switch result {
            case .success(let friend):
                completion(.success(friend))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }

    func acceptFriend(friend: Friend, completion: @escaping (Result<Friend, Error>) -> Void) {
        let friend = Friend(id: friend.id, senderUserId: friend.senderUserId, receiverUserId: friend.receiverUserId, friendState: FriendState.accepted.rawValue, updatedAt: Date(), createdAt: friend.createdAt)
        self.firebaseManager.addDocument(document: friend, collection: .friends, completion: { result in
            switch result {
            case .success(let friend):
                completion(.success(friend))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
    
    func removeFriend(friendId: String, completion: @escaping (Result<String, Error>) -> Void) {
        firebaseManager.removeDocument(documentID: friendId, collection: .friends) { result in
            switch result {
            case .success(let message):
                completion(.success(message))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func getFriendByPerson(person: User) -> Friend {
        return Friend(id: UUID().uuidString, senderUserId: DefaultsManager.shared.readUser().id, receiverUserId: person.id, friendState: FriendState.pending.rawValue, updatedAt: Date(), createdAt: Date())
    }

    func getFriend(person: User) -> Friend? {
        return friends.filter({ $0.senderUserId == person.id ||
            $0.receiverUserId == person.id
        }).first
    }
}
