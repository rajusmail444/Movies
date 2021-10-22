//
//  Movie.swift
//  Movies
//
//  Created by Rajesh Billakanti on 19/10/21.
//

import UIKit

struct MovieResponse: Decodable {
    var Poster: String
    var imdbID: String
    var Title: String
    
    init(
        imdbID: String,
        title: String,
        poster: String
    ) {
        self.imdbID = imdbID
        self.Title = title
        self.Poster = poster
    }
}

struct Movie {
    var id = UUID()
    var imdbID: String
    var title: String
    var poster: String
    
    init(
        imdbID: String,
        title: String,
        poster: String
    ) {
        self.imdbID = imdbID
        self.title = title
        self.poster = poster
    }
}

extension Movie: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Movie, rhs: Movie) -> Bool {
        lhs.id == rhs.id
    }
}
