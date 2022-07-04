//
//  NetworkManager.swift
//  social-network-app
//
//  Created by user on 1/7/22.
//

import Foundation

enum NetworkError: Error {
    case noData
}

class NetworkManager {
    
    static let shared = NetworkManager(session: URLSession.shared)
    
    let session: URLSession
    private (set) var headers = ["Content-Type": "application/json", "Accept-Chars": "UTF-8"]
    
    init(session: URLSession) {
        self.session = session
        // Set Authorization Header if needed
    }
    
    
    @discardableResult
    func get<T: Decodable>( _ type: T.Type, from url: URL, completion: @escaping (Result<T, Error>)  -> Void  ) -> URLSessionDataTask {
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                DispatchQueue.main.async {
                    completion( .failure(error)  )
                }
                return
            }

            let jsonDecoder = JSONDecoder()
            if let data  = data, let items = try? jsonDecoder.decode(type, from: data) {
                DispatchQueue.main.async {
                    completion( Result.success(items)  )
                }
            } else {
                DispatchQueue.main.async {
                    completion( .failure( NetworkError.noData )  )
                }
            }
        }
        task.resume()
        
        return task
    }
    
    @discardableResult
    func put<T: Decodable>( _ type: T.Type, from url: URL, completion: @escaping (Result<T, Error>)  -> Void  ) -> URLSessionDataTask {

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.allHTTPHeaderFields = headers
        let task = session.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                DispatchQueue.main.async {
                    completion( .failure(error)  )
                }
                return
            }

            let jsonDecoder = JSONDecoder()
            if let data  = data, let items = try? jsonDecoder.decode(type, from: data) {
                DispatchQueue.main.async {
                    completion( Result.success(items)  )
                }
            } else {
                DispatchQueue.main.async {
                    completion( .failure( NetworkError.noData )  )
                }
            }
        }
        task.resume()
        
        return task
    }
    
    
    @discardableResult
    func delete<T: Decodable>( _ type: T.Type, from url: URL, completion: @escaping (Result<T, Error>)  -> Void  ) -> URLSessionDataTask {

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.allHTTPHeaderFields = headers
        let task = session.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                DispatchQueue.main.async {
                    completion( .failure(error)  )
                }
                return
            }

            let jsonDecoder = JSONDecoder()
            if let data  = data, let items = try? jsonDecoder.decode(type, from: data) {
                DispatchQueue.main.async {
                    completion( Result.success(items)  )
                }
            } else {
                DispatchQueue.main.async {
                    completion( .failure( NetworkError.noData )  )
                }
            }
        }
        task.resume()
        
        return task
    }

    @discardableResult
    func post<T: Decodable>( _ type: T.Type, from url: URL, withBody body: Any, completion: @escaping (Result<T, Error>)  -> Void  ) -> URLSessionDataTask {

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.httpBody = httpPostBody(with: body)
        request.allHTTPHeaderFields = headers

        let task = session.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                DispatchQueue.main.async {
                    completion( .failure(error)  )
                }
                return
            }

            let jsonDecoder = JSONDecoder()
            if let data  = data, let items = try? jsonDecoder.decode(type, from: data) {
                DispatchQueue.main.async {
                    completion( Result.success(items)  )
                }
            } else {
                DispatchQueue.main.async {
                    completion( .failure( NetworkError.noData )  )
                }
            }
        }
        task.resume()
        
        return task
    }
    
    private func httpPostBody(with body: Any) -> Data? {
        if let bodyString = body as? String {
            return bodyString.data(using: .ascii, allowLossyConversion: true)
        } else {
            return try? JSONSerialization.data(withJSONObject: body)
        }
    }
    
    
}
