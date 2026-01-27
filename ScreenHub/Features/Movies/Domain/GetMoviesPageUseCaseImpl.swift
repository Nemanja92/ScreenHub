//
//  GetMoviesPageUseCaseImpl.swift
//  ScreenHub
//
//  Created by Nemanja Ignjatovic on 1/27/26.
//

import Foundation

struct GetMoviesPageUseCaseImpl: GetMoviesPageUseCase {

    private let repository: MoviesRepository

    init(repository: MoviesRepository) {
        self.repository = repository
    }

    func execute(page: Int) async throws -> MoviesPage {
        try await repository.getMovies(page: page)
    }
}
