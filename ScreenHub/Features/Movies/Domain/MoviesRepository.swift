//
//  MoviesRepository.swift
//  ScreenHub
//
//  Created by Nemanja Ignjatovic on 1/26/26.
//

import Foundation

protocol MoviesRepository {
    func getMovies(page: Int) async throws -> MoviesPage
}
