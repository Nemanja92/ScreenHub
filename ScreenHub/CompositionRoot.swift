//
//  CompositionRoot.swift
//  ScreenHub
//
//  Created by Nemanja Ignjatovic on 1/26/26.
//

import SwiftUI

enum CompositionRoot {

    static func makeMoviesListView() -> some View {
        let httpClient = HTTPClient()
        let api = MoviesAPIImpl(httpClient: httpClient)
        let remoteDataSource = MoviesRemoteDataSource(api: api)
        let repository = MoviesRepositoryImpl(remoteDataSource: remoteDataSource)
        let useCase = GetMoviesPageUseCaseImpl(repository: repository)
        let viewModel = MoviesListViewModel(getMoviesPage: useCase)

        return MoviesListView(viewModel: viewModel)
    }
}
