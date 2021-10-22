//
//  MoviesTests.swift
//  MoviesTests
//
//  Created by Rajesh Billakanti on 18/10/21.
//

import XCTest
@testable import Movies

class MoviesListViewModelTests: XCTestCase {
    private var sut: MoviesListViewModel!
    private var mockServiceWrapper: MockServiceWrapper!

    override func setUpWithError() throws {
        try super.setUpWithError()
        mockServiceWrapper = MockServiceWrapper()
        sut = MoviesListViewModel(serviceWrapper: mockServiceWrapper)
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
        mockServiceWrapper = nil
    }

    func testMovies_WhenApiSuccess() throws {
        // Given
        sut = MoviesListViewModel(serviceWrapper: mockServiceWrapper)
        
        // When
        sut.fetch(movie: "Marvel")
        
        // Then
        let movie = sut.movies.first
        XCTAssertEqual(sut.movies.count, 1)
        XCTAssertEqual(movie?.title, "Captain Marvel")
        XCTAssertEqual(movie?.imdbID, "tt4154664")
        XCTAssertEqual(movie?.poster, "Poster")
    }
    
    func testMovies_WhenApiFailed() throws {
        // Given
        sut = MoviesListViewModel(serviceWrapper: mockServiceWrapper)
        
        // When
        sut.fetch(movie: "")
        
        // Then
        XCTAssertEqual(sut.movies.count, 0)
    }
}
