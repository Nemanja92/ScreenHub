//
//  MoviesListViewModel.swift
//  ScreenHub
//
//  Created by Nemanja Ignjatovic on 1/26/26.
//

import Foundation
import Combine

@MainActor
final class MoviesListViewModel: ObservableObject {

    @Published private(set) var movies: [Movie] = []
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var errorMessage: String?

    private let getMoviesPage: GetMoviesPageUseCase
    private var pagination = PaginationState()

    private var hasLoaded = false

    init(getMoviesPage: GetMoviesPageUseCase) {
        self.getMoviesPage = getMoviesPage
    }

    func loadInitial() async {
        guard !hasLoaded else { return }
        hasLoaded = true

        pagination.reset()
        movies = []
        await loadNextPage()
    }

    func loadNextPage() async {
        guard pagination.hasMore, !pagination.isLoading else { return }

        pagination.startLoadingNextPage()
        isLoading = true
        errorMessage = nil

        do {
            let nextPage = pagination.currentPage + 1
            let page = try await getMoviesPage.execute(page: nextPage)
            movies.append(contentsOf: page.movies)
            pagination.finishLoading(page: page.page, hasMore: page.hasMore)
        } catch {
            errorMessage = error.localizedDescription
            pagination.isLoading = false
        }

        isLoading = false
    }
}
