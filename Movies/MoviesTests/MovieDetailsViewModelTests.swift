//
//  MovieDetailsViewModelTests.swift
//  MoviesTests
//
//  Created by Rajesh Billakanti on 21/10/21.
//

import XCTest
@testable import Movies

class MovieDetailsViewModelTests: XCTestCase {
    private var sut: MovieDetailsViewModel!
    private var mockServiceWrapper: MockServiceWrapper!

    override func setUpWithError() throws {
        try super.setUpWithError()
        mockServiceWrapper = MockServiceWrapper()
        sut = MovieDetailsViewModel(
            imdbID: "",
            serviceWrapper: mockServiceWrapper
        )
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
        mockServiceWrapper = nil
    }

    func testMovies_WhenApiSuccess() throws {
        // Given
        sut = MovieDetailsViewModel(
            imdbID: "tt4154664",
            serviceWrapper: mockServiceWrapper
        )
        
        // When
        sut.fetch(imdbID: "tt4154664")
        
        // Then
        XCTAssertEqual(sut.details?.title, "Spider-Man")
        XCTAssertEqual(sut.details?.year, "2002")
        XCTAssertEqual(sut.details?.runtime, "121 min")
        XCTAssertEqual(sut.details?.director, "Sam Raimi")
        XCTAssertEqual(sut.details?.writer, "Stan Lee, Steve Ditko, David Koepp")
        XCTAssertEqual(sut.details?.actors, "Tobey Maguire, Kirsten Dunst, Willem Dafoe")
        XCTAssertEqual(sut.details?.plot, "plot info")
        XCTAssertEqual(sut.details?.imdbRating, "7.3")
        XCTAssertEqual(sut.details?.imdbVotes, "724,041")
        XCTAssertEqual(sut.details?.poster, "poster url")
        XCTAssertEqual(sut.details?.metascore, "73")
    }
    
    func testMovies_WhenApiFailed() throws {
        // Given
        sut = MovieDetailsViewModel(
            imdbID: "",
            serviceWrapper: mockServiceWrapper
        )
        
        // When
        sut.fetch(imdbID: "")
        
        // Then
        XCTAssertEqual(sut.details?.title, nil)
    }
}

