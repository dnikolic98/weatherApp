//
//  URLSession+Extension.swift
//  weatherApp
//
//  Created by Dario Nikolic on 01/09/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

import Foundation

extension URLSession {

    typealias DataTaskCompletion = (Result<(HTTPURLResponse, Data), Error>) -> Void

    func dataTask(with request: URLRequest, completion: @escaping DataTaskCompletion) -> URLSessionDataTask {
        return self.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(Result.failure(NetworkError.transportError(error)))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                completion(Result.failure(NetworkError.noResponse))
                return
            }
            
            let statusCode = response.statusCode
            guard (200...299).contains(statusCode) else {
                completion(Result.failure(NetworkError.serverSideError(statusCode)))
                return
            }
            
            guard let data = data else {
                completion(Result.failure(NetworkError.noData))
                return
            }
            
            completion(Result.success((response, data)))
        }
    }
}
