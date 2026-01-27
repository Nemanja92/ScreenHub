//
//  MoviesPage.swift
//  ScreenHub
//
//  Created by Nemanja Ignjatovic on 1/26/26.
//

import Foundation

struct MoviesPage: Equatable {
    let movies: [Movie]
    let page: Int
    let hasMore: Bool
}
