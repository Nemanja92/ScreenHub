//
//  MoviesListViewModelTests.swift
//  ScreenHub
//
//  Created by Nemanja Ignjatovic on 1/26/26.
//

import Foundation
import Testing
@testable import ScreenHub

@Suite
struct MoviesListViewModelTests {

    @Test
    @MainActor
    func loadInitial_loadsFirstPage() async {
        let page1 = MoviesPage(
            movies: [MovieFixtures.movieA],
            page: 1,
            hasMore: true
        )

        let repository = FakeMoviesRepository(pages: [page1])
        let useCase: GetMoviesPageUseCase = GetMoviesPageUseCaseImpl(repository: repository)
        let viewModel = MoviesListViewModel(getMoviesPage: useCase)

        await viewModel.loadInitial()

        #expect(viewModel.movies.count == 1)
        #expect(viewModel.movies.first?.id == MovieFixtures.movieA.id)
        #expect(repository.requestedPages == [1])
        #expect(viewModel.errorMessage == nil)
    }

    @Test
    @MainActor
    func loadMoreIfNeeded_requestsNextPage_whenLastItemAppears() async {
        let page1 = MoviesPage(
            movies: [MovieFixtures.movieA],
            page: 1,
            hasMore: true
        )

        let page2 = MoviesPage(
            movies: [MovieFixtures.movieB],
            page: 2,
            hasMore: false
        )

        let repository = FakeMoviesRepository(pages: [page1, page2])
        let useCase: GetMoviesPageUseCase = GetMoviesPageUseCaseImpl(repository: repository)
        let viewModel = MoviesListViewModel(getMoviesPage: useCase)

        await viewModel.loadInitial()

        // Trigger pagination the same way the UI does: last item appears.
        await viewModel.loadMoreIfNeeded(currentItemId: MovieFixtures.movieA.id)

        #expect(viewModel.movies.map(\.id) == [
            MovieFixtures.movieA.id,
            MovieFixtures.movieB.id
        ])

        #expect(repository.requestedPages == [1, 2])
        #expect(viewModel.errorMessage == nil)
    }
}

//
// MARK: - Test Doubles
//

private final class FakeMoviesRepository: MoviesRepository {

    private let pagesByNumber: [Int: MoviesPage]
    private(set) var requestedPages: [Int] = []

    init(pages: [MoviesPage]) {
        self.pagesByNumber = Dictionary(
            uniqueKeysWithValues: pages.map { ($0.page, $0) }
        )
    }

    func getMovies(page: Int) async throws -> MoviesPage {
        requestedPages.append(page)
        return pagesByNumber[page]
            ?? MoviesPage(movies: [], page: page, hasMore: false)
    }
}

//
// MARK: - Fixtures
//

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
}
