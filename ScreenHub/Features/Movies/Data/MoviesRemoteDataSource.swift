//
//  MoviesRemoteDataSource.swift
//  ScreenHub
//
//  Created by Nemanja Ignjatovic on 1/26/26.
//

import Foundation

protocol MoviesRemoteDataSource {
    func fetch(page: Int) async throws -> MoviesPage
}

final class MoviesRemoteDataSourceImpl: MoviesRemoteDataSource {

    private let api: MoviesAPI

    init(api: MoviesAPI) {
        self.api = api
    }

    func fetch(page: Int) async throws -> MoviesPage {
        try await api.fetchMoviesPage(page: page)
    }
}
