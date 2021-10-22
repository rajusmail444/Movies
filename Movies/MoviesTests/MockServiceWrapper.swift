//
//  MockServiceWrapper.swift
//  MoviesTests
//
//  Created by Rajesh Billakanti on 21/10/21.
//

import Foundation
import Movies

public final class MockServiceWrapper: ServiceWrapperType {
    public func fetch<T>(
        queryItems: [URLQueryItem],
        memberType: T.Type,
        completion: @escaping (Result<T, Error>) -> ()
    ) where T : Decodable {
        var data: [String : Any]?
        if memberType is Movies.SectionResponse.Type {
            data = getSectionResponseData()
        } else if memberType is Movies.DetailsResponse.Type {
            data = getDetailsResponseData()
        }
        
        if let objData = try? JSONSerialization
            .data(withJSONObject: data as Any),
            let decodedData = try? JSONDecoder().decode(memberType, from: objData),
            let query = queryItems[0].value, !query.isEmpty {
            print("~> decodedData: \(decodedData)")
            completion(.success(decodedData))
        } else {
            completion(.failure(ServiceError.parsingError))
        }
    }
    
    private func getSectionResponseData() -> [String : Any] {
        return [
            "Search" : [[
                "Poster": "Poster",
                "Title": "Captain Marvel",
                "Type": "movie",
                "Year": "2019",
                "imdbID": "tt4154664"
            ]],
            "totalResults": "123"
        ] as [String : Any]
    }
    
    private func getDetailsResponseData() -> [String : Any] {
        return [
            "Title": "Spider-Man",
            "Year": "2002",
            "Runtime": "121 min",
            "Director": "Sam Raimi",
            "Writer": "Stan Lee, Steve Ditko, David Koepp",
            "Actors": "Tobey Maguire, Kirsten Dunst, Willem Dafoe",
            "Plot": "plot info",
            "imdbRating": "7.3",
            "imdbVotes": "724,041",
            "Poster": "poster url",
            "Metascore": "73",
            "Type": "Movie"
        ] as [String : Any]
    }
}
