//
//  MoviesListViewModel.swift
//  ScreenHub
//
//  Created by Nemanja Ignjatovic on 1/26/26.
//

import Foundation
import Observation

enum LoadState: Equatable {
    case idle
    case loading
    case loaded
    case loadingNextPage
    case failed(String)
}

@MainActor
@Observable
final class MoviesListViewModel {
    private let getMoviesPage: GetMoviesPageUseCase

    private(set) var movies: [Movie] = []
    private(set) var loadState: LoadState = .idle
    private(set) var currentPage: Int = 0
    private(set) var hasMore: Bool = true

    private var hasAttemptedInitialLoad = false

    init(getMoviesPage: GetMoviesPageUseCase) {
        self.getMoviesPage = getMoviesPage
    }

    func loadInitial() async {
        guard !hasAttemptedInitialLoad else { return }
        hasAttemptedInitialLoad = true
        await reloadFromStart()
    }

    func retryInitialLoad() async {
        await reloadFromStart()
    }

    func loadMoreIfNeeded(currentItem: Movie) async {
        guard shouldLoadMore(for: currentItem) else { return }

        loadState = .loadingNextPage

        do {
            let nextPage = currentPage + 1
            let response = try await getMoviesPage.execute(page: nextPage)

            movies.append(contentsOf: response.movies)
            currentPage = response.page
            hasMore = response.hasMore
            loadState = .loaded
        } catch {
            loadState = .failed("Failed to load more movies.")
        }
    }

    private func reloadFromStart() async {
        guard loadState != .loading else { return }

        loadState = .loading
        movies = []
        currentPage = 0
        hasMore = true

        do {
            let response = try await getMoviesPage.execute(page: 1)

            movies = response.movies
            currentPage = response.page
            hasMore = response.hasMore
            loadState = .loaded
        } catch {
            loadState = .failed("Failed to load movies.")
        }
    }

    private func shouldLoadMore(for currentItem: Movie) -> Bool {
        guard hasMore else { return false }
        guard loadState != .loading else { return false }
        guard loadState != .loadingNextPage else { return false }
        guard movies.last?.id == currentItem.id else { return false }
        return true
    }
}
