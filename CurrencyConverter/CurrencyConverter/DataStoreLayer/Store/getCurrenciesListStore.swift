//
//  getCurrenciesListStore.swift
//  CurrencyConverter
//
//  Created by admin on 21/03/2022.
//

import Foundation

protocol APIServiceProtocol {
    func getDataFromURL(_ endPoint: EndPoint, completion: @escaping (Result<Data, APIError>) -> ())
}

final class APIService: APIServiceProtocol {
        
    func getDataFromURL(_ endPoint: EndPoint, completion: @escaping (Result<Data, APIError>) -> ()) {
        
        guard let url = endPoint.url else {
            return completion(.failure(APIError.invalidURL))
        }
        /// Check is internet available
        if !Utilities.isInternetAvailable() {
            completion(.failure(APIError.noNetwork))
            return
        }
        /// Set URLRequest and type
        var request = URLRequest(url: url)
        request.httpMethod = endPoint.method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        if let data = endPoint.data {
            request.httpBody = data
        }
        print("request+++++++++++\(request)")


        /// Make request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, 200..<299 ~= statusCode else {
                completion(.failure(APIError.checkErrorCode((response as? HTTPURLResponse)?.statusCode ?? 0)))
                return
            }
            guard data != nil else {
                completion(.failure(APIError.noData))
                return
            }
            print("data+++++++++++\(data)")
            
            completion(.success(data!))
        }
        task.resume()
    }
    
}

