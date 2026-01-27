//
//  MoviesRemoteDataSource.swift
//  ScreenHub
//
//  Created by Nemanja Ignjatovic on 1/26/26.
//

import Foundation

final class MoviesRemoteDataSource {

    // maxPage is hardcoded to match the demo API setup,
    // which exposes a fixed number of paged JSON files.
    // In a real backend-driven API, this value would be provided dynamically.
    private let api: MoviesAPI
    private let maxPage: Int = 3

    init(api: MoviesAPI) {
        self.api = api
    }

    func fetchMoviesPage(page: Int) async throws -> MoviesPage {
        let movies = try await api.fetchMovies(page: page)
        let hasMore = page < maxPage && !movies.isEmpty
        return MoviesPage(movies: movies, page: page, hasMore: hasMore)
    }
}
