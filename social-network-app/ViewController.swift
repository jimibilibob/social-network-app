//
//  ViewController.swift
//  social-network-app
//
//  Created by user on 29/6/22.
//


import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var viewController: UIView!
    let firebaseManager = FirebaseManager.shared

    var users = [User]()
    var userID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewController.layer.cornerRadius = 25
        userID = firebaseManager.getDocID(forCollection: .users)
        
        firebaseManager.listenCollectionChanges(type: User.self, collection: .users) { result in
            self.listenUserChanges(result: result)
        }
    }
    
    
    func listenUserChanges(result: Result<[User], Error>) {
        switch result {
        case .success(let users):
            self.users = users
            printUsers()
        case .failure(let error):
            print("Error", error)
        }
    }
    

    
    @IBAction func addUser(_ sender: Any) {
        
        let user = User(id: userID, name: "UserOne", age: 21, email: "jimibilibob@random.ra", password: "1243")
        
        firebaseManager.addDocument(document: user, collection: .users) { result in
            switch result {
            case .success(let user):
                print("Success", user)
            case .failure(let error):
                print("Error", error)
            }
        }
    }

    
    
    @IBAction func editUser(_ sender: Any) {
        let user = User(id: userID, name: "UserOneEdited", age: 28, email: "another@gmail.com", password: "123456789")

        firebaseManager.updateDocument(document: user, collection: .users) { result in
            switch result {
            case .success(let user):
                print("Success", user)
            case .failure(let error):
                print("Error", error)
            }
        }
    }
    
    
    @IBAction func removeUser(_ sender: Any) {
        firebaseManager.removeDocument(documentID: userID, collection: .users){ result in
            switch result {
            case .success(let user):
                print("Success", user)
            case .failure(let error):
                print("Error", error)
            }
        }
    }
    
    // helpers
    func printUsers() {
        var str = ""
        for user in users {
            str += "\(user.id), \(user.name), \(user.age)\n"
        }
        dataLabel.text = str
    }
    
}


