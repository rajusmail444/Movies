//
//  MoviesListViewModel.swift
//  Movies
//
//  Created by Rajesh Billakanti on 19/10/21.
//

import Foundation
import Combine

public final class MoviesListViewModel {
    @Published var moviesCount: Int = 0
    var movies: [Movie] = []
    var page: Int = 0
    var totalresults: Int = 100
    public let title: String
    private let serviceWrapper: ServiceWrapperType
    init(serviceWrapper: ServiceWrapperType) {
        title = "Movies"
        self.serviceWrapper = serviceWrapper
    }
    
    func fetch(movie: String, page: Int = 1) {
        serviceWrapper.fetch(
            queryItems: [URLQueryItem(name: "s", value: movie),
                         URLQueryItem(name: "type", value: "movie"),
                         URLQueryItem(name: "page", value: "\(page)")],
            memberType: SectionResponse.self
        ) { [weak self] (result) in
            switch result {
            case .success(let response) :
                self?.movies.append(
                    contentsOf: self?.processMovies(moviesresp: response.Search) ?? []
                )
                self?.moviesCount = self?.movies.count ?? 0
                self?.page = page
                self?.totalresults = Int(response.totalResults) ?? 100
            case .failure(let error) :
                print("~>error: \(error)")
            }
        }
    }
    
    private func processMovies(moviesresp: [MovieResponse]) -> [Movie] {
        return moviesresp.map { movie in
            Movie(
                imdbID: movie.imdbID,
                title: movie.Title,
                poster: movie.Poster
            )
        }
    }
}
