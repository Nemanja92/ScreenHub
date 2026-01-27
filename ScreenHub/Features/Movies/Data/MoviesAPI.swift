//
//  MoviesAPI.swift
//  ScreenHub
//
//  Created by Nemanja Ignjatovic on 1/26/26.
//

import Foundation

protocol MoviesAPI {
    func fetchMovies(page: Int) async throws -> [Movie]
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

    func fetchMovies(page: Int) async throws -> [Movie] {
        guard page > 0 else { return [] }

        let url = baseURL.appendingPathComponent("movies_page_\(page).json")
        return try await httpClient.get(url)
    }
}
