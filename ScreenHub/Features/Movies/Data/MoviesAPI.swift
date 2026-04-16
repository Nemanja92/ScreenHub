//
//  MoviesAPI.swift
//  ScreenHub
//
//  Created by Nemanja Ignjatovic on 1/26/26.
//

import Foundation

protocol MoviesAPI {
    func fetchMoviesPage(page: Int) async throws -> MoviesPage
}

final class MoviesAPIImpl: MoviesAPI {

    private let httpClient: HTTPClient
    private let baseURL: URL

    init(
        httpClient: HTTPClient,
        baseURL: URL = URL(string: "https://raw.githubusercontent.com/Nemanja92/screenhub-demo-api/refs/heads/main")!
    ) {
        self.httpClient = httpClient
        self.baseURL = baseURL
    }

    func fetchMoviesPage(page: Int) async throws -> MoviesPage {
        guard page > 0 else {
            return MoviesPage(movies: [], page: page, hasMore: false)
        }

        let url = baseURL.appendingPathComponent("movies_page_\(page).json")
        return try await httpClient.get(url)
    }
}
