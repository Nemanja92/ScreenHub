//
//  SearchMovieUseCaseTests.swift
//  ScreenHub
//
//  Created by Nemanja Ignjatovic on 4/17/26.
//

import Foundation
import Testing
@testable import ScreenHub

@Suite
struct SearchMovieUseCaseTests {

    private let sut: SearchMovieUseCase = SearchMovieUseCaseImpl()

    @Test
    func execute_returnsAllMovies_whenQueryIsEmpty() {
        let movies = [
            MovieFixtures.movieA,
            MovieFixtures.darkKnight,
            MovieFixtures.movieB
        ]

        let result = sut.execute(movies: movies, query: "")

        #expect(result == movies)
    }

    @Test
    func execute_returnsAllMovies_whenQueryContainsOnlyWhitespace() {
        let movies = [
            MovieFixtures.movieA,
            MovieFixtures.darkKnight,
            MovieFixtures.movieB
        ]

        let result = sut.execute(movies: movies, query: "   ")

        #expect(result == movies)
    }

    @Test
    func execute_filtersMoviesByTitle() {
        let movies = [
            MovieFixtures.movieA,
            MovieFixtures.darkKnight,
            MovieFixtures.movieB
        ]

        let result = sut.execute(movies: movies, query: "Dark")

        #expect(result.map(\.id) == [MovieFixtures.darkKnight.id])
    }

    @Test
    func execute_isCaseInsensitive() {
        let movies = [
            MovieFixtures.movieA,
            MovieFixtures.darkKnight,
            MovieFixtures.movieB
        ]

        let result = sut.execute(movies: movies, query: "movie")

        #expect(result.map(\.id) == [
            MovieFixtures.movieA.id,
            MovieFixtures.movieB.id
        ])
    }
}

private enum MovieFixtures {

    static let movieA = Movie(
        id: "movie_a",
        title: "Movie A",
        year: 2020,
        runtimeMinutes: 120,
        genres: ["Drama"],
        plot: "Test plot A",
        posterUrl: URL(string: "https://example.com/a.jpg"),
        trailerUrl: URL(string: "https://example.com/a.mp4"),
        rating: 8.5,
        directors: ["Director A"],
        cast: ["Actor A"],
        releaseDate: "2020-01-01"
    )

    static let movieB = Movie(
        id: "movie_b",
        title: "Movie B",
        year: 2021,
        runtimeMinutes: 110,
        genres: ["Action"],
        plot: "Test plot B",
        posterUrl: URL(string: "https://example.com/b.jpg"),
        trailerUrl: URL(string: "https://example.com/b.mp4"),
        rating: 7.9,
        directors: ["Director B"],
        cast: ["Actor B"],
        releaseDate: "2021-01-01"
    )

    static let darkKnight = Movie(
        id: "dark_knight",
        title: "The Dark Knight",
        year: 2008,
        runtimeMinutes: 152,
        genres: ["Action", "Crime"],
        plot: "Batman faces the Joker.",
        posterUrl: URL(string: "https://example.com/darkknight.jpg"),
        trailerUrl: URL(string: "https://example.com/darkknight.mp4"),
        rating: 9.0,
        directors: ["Christopher Nolan"],
        cast: ["Christian Bale", "Heath Ledger"],
        releaseDate: "2008-07-18"
    )
}
