//
//  Movie.swift
//  Movies
//
//  Created by Rajesh Billakanti on 19/10/21.
//

import UIKit

public struct DetailsResponse: Decodable {
    var Title: String
    var Year: String
    var Runtime: String
    var Director: String
    var Writer: String
    var Actors: String
    var Plot: String
    var imdbRating: String
    var imdbVotes: String
    var Poster: String
    var Metascore: String
    var `Type`: String
    
    init(
        title: String,
        year: String,
        runtime: String,
        director: String,
        writer: String,
        actors: String,
        plot: String,
        imdbRating: String,
        imdbVotes: String,
        poster: String,
        metascore: String,
        type: String
    ) {
        self.Title = title
        self.Year = year
        self.Runtime = runtime
        self.Director = director
        self.Writer = writer
        self.Actors = actors
        self.Plot = plot
        self.imdbRating = imdbRating
        self.imdbVotes = imdbVotes
        self.Poster = poster
        self.Metascore = metascore
        self.Type = type
    }
}

struct Details {
    var id = UUID()
    var title: String
    var year: String
    var runtime: String
    var director: String
    var writer: String
    var actors: String
    var plot: String
    var imdbRating: String
    var imdbVotes: String
    var poster: String
    var metascore: String
    var type: String
    
    init(
        title: String,
        year: String,
        runtime: String,
        director: String,
        writer: String,
        actors: String,
        plot: String,
        imdbRating: String,
        imdbVotes: String,
        poster: String,
        metascore: String,
        type: String
    ) {
        self.title = title
        self.year = year
        self.director = director
        self.writer = writer
        self.actors = actors
        self.plot = plot
        self.imdbRating = imdbRating
        self.imdbVotes = imdbVotes
        self.poster = poster
        self.runtime = runtime
        self.metascore = metascore
        self.type = type
    }
    
    var duration: String {
        let runtimeArr = self.runtime.split(separator: " ")
        let min = Int(runtimeArr[0]) ?? 0
        let hours = Int(min/60)
        let minutes = min%60
        return "\(hours)h \(minutes)m"
    }
}

extension Details: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Details, rhs: Details) -> Bool {
        lhs.id == rhs.id
    }
}
