//
//  CompositionRoot.swift
//  ScreenHub
//
//  Created by Nemanja Ignjatovic on 1/26/26.
//

import SwiftUI

enum CompositionRoot {

    static func makeMoviesListView() -> some View {
        MoviesListView(viewModel: makeMoviesListViewModel())
    }

    // MARK: - ViewModels

    @MainActor
    static func makeMoviesListViewModel() -> MoviesListViewModel {
        MoviesListViewModel(
            getMoviesPage: makeGetMoviesPageUseCase(),
            searchMovies: makeSearchMoviesUseCase(),
            filterMovies: makeFilterMovieUseCase()
        )
    }

    // MARK: - UseCases

    static func makeGetMoviesPageUseCase() -> GetMoviesPageUseCase {
        GetMoviesPageUseCaseImpl(repository: makeMoviesRepository())
    }

    static func makeSearchMoviesUseCase() -> SearchMovieUseCase {
        SearchMovieUseCaseImpl()
    }
    
    static func makeFilterMovieUseCase() -> FilterMovieUseCase {
        FilterMovieUseCaseImpl()
    }

    // MARK: - Repositories

    static func makeMoviesRepository() -> MoviesRepository {
        MoviesRepositoryImpl(remoteDataSource: makeMoviesRemoteDataSource())
    }

    // MARK: - DataSources

    static func makeMoviesRemoteDataSource() -> MoviesRemoteDataSource {
        MoviesRemoteDataSourceImpl(api: makeMoviesAPI())
    }

    // MARK: - API / Infrastructure

    static func makeMoviesAPI() -> MoviesAPI {
        MoviesAPIImpl(httpClient: makeHTTPClient())
    }

    static func makeHTTPClient() -> HTTPClient {
        HTTPClient()
    }
}
