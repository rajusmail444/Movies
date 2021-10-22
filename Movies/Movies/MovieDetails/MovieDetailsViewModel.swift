//
//  MovieDetailsViewModel.swift
//  Movies
//
//  Created by Rajesh Billakanti on 20/10/21.
//

import Foundation
import Combine

public final class MovieDetailsViewModel {
    @Published var detailsRetrieved: Bool = false
    var details: Details?
    private let serviceWrapper: ServiceWrapperType
    private let imdbID: String
    init(imdbID: String, serviceWrapper: ServiceWrapperType) {
        self.imdbID = imdbID
        self.serviceWrapper = serviceWrapper
        fetch(imdbID: imdbID)
    }
    
    func fetch(imdbID: String) {
        serviceWrapper.fetch(
            queryItems: [URLQueryItem(name: "i", value: imdbID)],
            memberType: DetailsResponse.self
        ) { [weak self] (result) in
            switch result {
            case .success(let response) :
                self?.details = self?.processDetails(details: response)
                self?.detailsRetrieved = true
            case .failure(let error) :
                print("~> Movie Details error: \(error)")
            }
        }
    }
    
    private func processDetails(details: DetailsResponse) -> Details {
        return Details(
            title: details.Title,
            year: details.Year,
            runtime: details.Runtime,
            director: details.Director,
            writer: details.Writer,
            actors: details.Actors,
            plot: details.Plot,
            imdbRating: details.imdbRating,
            imdbVotes: details.imdbVotes,
            poster: details.Poster,
            metascore: details.Metascore,
            type: details.Type
        )
    }
    
}

