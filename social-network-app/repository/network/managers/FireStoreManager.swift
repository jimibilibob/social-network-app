//
//  FireStoreManager.swift
//  social-network-app
//
//  Created by user on 14/7/22.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import UIKit

class FirebaseStorageManager {
    static let shared = FirebaseStorageManager()
    
    func uploadPhoto(file: UIImage, route: String, completion: @escaping (_ url: URL) -> Void) {
        let randomID = UUID.init().uuidString
        let uploadRef = Storage.storage().reference(withPath: "\(route)/\(randomID).jpg")
        guard let imageData = file.jpegData(compressionQuality: 0.75) else {return}

        let uploadMetadata = StorageMetadata.init()

        uploadMetadata.contentType = "image/jpeg"

        uploadRef.putData(imageData, metadata: uploadMetadata) { (downloadedMetada, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            print("Completed")
            
            uploadRef.downloadURL(completion: {(url, error) in
                if let error = error {
                    print("Error generating url \(error.localizedDescription)")
                    return
                }
                if let url = url {
                    print("URL: \(url.absoluteString)")
                    completion(url)
                }
            })
        }
    }

    func deleteFile(fileName: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        let desertRef = Storage.storage().reference(withPath: "photos/").child(fileName)
        desertRef.delete { error in
            if error != nil {
              completion(.failure(error!))
              return
            }
            completion(.success(true))
            return
        }
    }
}
