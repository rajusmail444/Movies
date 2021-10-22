//
//  Service.swift
//  Movies
//
//  Created by Rajesh Billakanti on 19/10/21.
//

import Foundation
import Combine

public protocol ServiceWrapperType {
    func fetch<T: Decodable>(
        queryItems: [URLQueryItem],
        memberType: T.Type,
        completion: @escaping (Result<T, Error>) -> ()
    )
}

final class ServiceWrapper: ServiceWrapperType {
    init() {}
    
    func fetch<T: Decodable>(
        queryItems: [URLQueryItem],
        memberType: T.Type,
        completion: @escaping (Result<T, Error>) -> ()
    ) {
        let hostUrl = URL(string: "https://www.omdbapi.com/?")!
        let apiKey = [URLQueryItem(name: "apikey", value: "b9bd48a6")]
        let url = hostUrl.appending(apiKey + queryItems)!
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let objError = error {
                completion(.failure(ServiceError.networkingError(error: objError)))
            }
            if let objData = data,
               let objURLResponse = response as? HTTPURLResponse,
               let decodedData = try? JSONDecoder().decode(memberType, from: objData) {
                
                if objURLResponse.statusCode == 200 {
                    completion(.success(decodedData))
                } else {
                    completion(.failure(ServiceError.parsingError))
                }
            }
        }.resume()
    }
}
