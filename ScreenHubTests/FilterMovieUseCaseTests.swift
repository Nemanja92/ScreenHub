//
//  FilterMovieUseCaseTests.swift
//  ScreenHub
//
//  Created by Nemanja Ignjatovic on 4/17/26.
//

import Foundation
import Testing
@testable import ScreenHub

@Suite
struct FilterMovieUseCaseTests {

    private let sut: FilterMovieUseCase = FilterMovieUseCaseImpl()

    @Test
    func execute_returnsAllMovies_whenMinimumRatingIsZero() {
        let movies = [
            MovieFixtures.movieLow,
            MovieFixtures.movieMedium,
            MovieFixtures.movieHigh
        ]

        let filter = MoviesFilter(minimumRating: 0)

        let result = sut.execute(movies: movies, filter: filter)

        #expect(result == movies)
    }

    @Test
    func execute_filtersOutMoviesBelowMinimumRating() {
        let movies = [
            MovieFixtures.movieLow,
            MovieFixtures.movieMedium,
            MovieFixtures.movieHigh
        ]

        let filter = MoviesFilter(minimumRating: 8.0)

        let result = sut.execute(movies: movies, filter: filter)

        #expect(result.map(\.id) == [MovieFixtures.movieHigh.id])
    }

    @Test
    func execute_keepsMoviesEqualToMinimumRating() {
        let movies = [
            MovieFixtures.movieMedium,
            MovieFixtures.movieHigh
        ]

        let filter = MoviesFilter(minimumRating: 7.5)

        let result = sut.execute(movies: movies, filter: filter)

        #expect(result.map(\.id) == [
            MovieFixtures.movieMedium.id,
            MovieFixtures.movieHigh.id
        ])
    }
}

private enum MovieFixtures {

    static let movieLow = Movie(
        id: "movie_low",
        title: "Movie Low",
        year: 2020,
        runtimeMinutes: 100,
        genres: ["Drama"],
        plot: "Low rating movie",
        posterUrl: nil,
        trailerUrl: nil,
        rating: 6.2,
        directors: ["Director Low"],
        cast: ["Actor Low"],
        releaseDate: "2020-01-01"
    )

    static let movieMedium = Movie(
        id: "movie_medium",
        title: "Movie Medium",
        year: 2021,
        runtimeMinutes: 110,
        genres: ["Drama"],
        plot: "Medium rating movie",
        posterUrl: nil,
        trailerUrl: nil,
        rating: 7.5,
        directors: ["Director Medium"],
        cast: ["Actor Medium"],
        releaseDate: "2021-01-01"
    )

    static let movieHigh = Movie(
        id: "movie_high",
        title: "Movie High",
        year: 2022,
        runtimeMinutes: 120,
        genres: ["Action"],
        plot: "High rating movie",
        posterUrl: nil,
        trailerUrl: nil,
        rating: 8.9,
        directors: ["Director High"],
        cast: ["Actor High"],
        releaseDate: "2022-01-01"
    )
}
