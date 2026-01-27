//
//  MoviesRepositoryImpl.swift
//  ScreenHub
//
//  Created by Nemanja Ignjatovic on 1/26/26.
//

import Foundation

final class MoviesRepositoryImpl: MoviesRepository {

    private let remoteDataSource: MoviesRemoteDataSource

    init(remoteDataSource: MoviesRemoteDataSource) {
        self.remoteDataSource = remoteDataSource
    }

    func getMovies(page: Int) async throws -> MoviesPage {
        try await remoteDataSource.fetchMoviesPage(page: page)
    }
}
