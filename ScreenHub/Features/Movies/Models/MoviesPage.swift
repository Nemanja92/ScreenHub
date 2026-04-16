//
//  MoviesPage.swift
//  ScreenHub
//
//  Created by Nemanja Ignjatovic on 1/26/26.
//

import Foundation

struct MoviesPage: Decodable, Sendable {
    let movies: [Movie]
    let page: Int
    let hasMore: Bool

    private enum CodingKeys: String, CodingKey {
        case movies
        case page
        case hasMore = "hasNextPage"
    }
}
