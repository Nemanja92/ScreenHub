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
    private let searchMovies: SearchMovieUseCase
    private let filterMovies: FilterMovieUseCase

    private var allMovies: [Movie] = []
    private var hasAttemptedInitialLoad = false
    private var searchTask: Task<Void, Never>?
    private(set) var filter: MoviesFilter = MoviesFilter()

    var searchText: String = "" {
        didSet {
            scheduleSearchRecompute()
        }
    }

    private(set) var movies: [Movie] = []
    private(set) var loadState: LoadState = .idle
    private(set) var currentPage: Int = 0
    private(set) var hasMore: Bool = true
    private(set) var paginationErrorMessage: String?

    init(
        getMoviesPage: GetMoviesPageUseCase,
        searchMovies: SearchMovieUseCase,
        filterMovies: FilterMovieUseCase
    ) {
        self.getMoviesPage = getMoviesPage
        self.searchMovies = searchMovies
        self.filterMovies = filterMovies
    }

    func loadInitial() async {
        guard !hasAttemptedInitialLoad else { return }
        hasAttemptedInitialLoad = true
        await reloadFromStart()
    }

    func retryInitialLoad() async {
        await reloadFromStart()
    }

    func retryLoadMore() async {
        guard let lastMovie = movies.last else { return }
        await loadMoreIfNeeded(currentItem: lastMovie)
    }

    func loadMoreIfNeeded(currentItem: Movie) async {
        guard shouldLoadMore(for: currentItem) else { return }

        loadState = .loadingNextPage
        paginationErrorMessage = nil

        do {
            let nextPage = currentPage + 1
            let response = try await getMoviesPage.execute(page: nextPage)

            allMovies.append(contentsOf: response.movies)
            recomputeVisibleMovies()

            currentPage = response.page
            hasMore = response.hasMore
            loadState = .loaded
        } catch {
            loadState = .loaded
            paginationErrorMessage = "Failed to load more movies."
        }
    }

    private func reloadFromStart() async {
        guard loadState != .loading else { return }

        searchTask?.cancel()
        loadState = .loading
        paginationErrorMessage = nil
        allMovies = []
        movies = []
        currentPage = 0
        hasMore = true

        do {
            let response = try await getMoviesPage.execute(page: 1)

            allMovies = response.movies
            recomputeVisibleMovies()

            currentPage = response.page
            hasMore = response.hasMore
            loadState = .loaded
        } catch {
            loadState = .failed("Failed to load movies.")
        }
    }

    private func scheduleSearchRecompute() {
        searchTask?.cancel()

        let currentQuery = searchText

        searchTask = Task { [weak self] in
            try? await Task.sleep(for: .milliseconds(300))

            guard !Task.isCancelled else { return }

            await MainActor.run {
                guard let self else { return }
                guard self.searchText == currentQuery else { return }
                self.recomputeVisibleMovies()
            }
        }
    }

    private func recomputeVisibleMovies() {
        let filteredMovies = filterMovies.execute(movies: allMovies, filter: filter)
        movies = searchMovies.execute(movies: filteredMovies, query: searchText)
    }

    private func shouldLoadMore(for currentItem: Movie) -> Bool {
        guard hasMore else { return false }
        guard loadState != .loading else { return false }
        guard loadState != .loadingNextPage else { return false }
        guard movies.last?.id == currentItem.id else { return false }
        return true
    }
    
    func updateFilter(_ newFilter: MoviesFilter) {
        guard filter != newFilter else { return }
        searchTask?.cancel()
        filter = newFilter
        recomputeVisibleMovies()
    }
}
