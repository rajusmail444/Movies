//
//  Section.swift
//  Movies
//
//  Created by Rajesh Billakanti on 19/10/21.
//

import UIKit

public struct SectionResponse: Decodable {
    var Search: [MovieResponse]
    var totalResults: String
    
    init(
        search: [MovieResponse],
        totalResults: String
    ) {
        self.Search = search
        self.totalResults = totalResults
    }
}

enum Section {
    case main
}
