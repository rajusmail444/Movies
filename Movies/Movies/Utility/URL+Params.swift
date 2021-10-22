//
//  URL+Params.swift
//  Movies
//
//  Created by Rajesh Billakanti on 19/10/21.
//

import Foundation

extension URL {
    /// Returns a new URL by adding the query items, or nil if the URL doesn't support it.
    /// URL must conform to RFC 3986.
    func appending(_ queryItems: [URLQueryItem]) -> URL? {
        guard var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: true) else {
            return nil
        }
        urlComponents.queryItems = (urlComponents.queryItems ?? []) + queryItems
        
        return urlComponents.url
    }
}
