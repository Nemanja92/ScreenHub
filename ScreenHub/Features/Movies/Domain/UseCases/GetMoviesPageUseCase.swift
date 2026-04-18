//
//  GetMoviesPageUseCase.swift
//  ScreenHub
//
//  Created by Nemanja Ignjatovic on 1/26/26.
//

import Foundation

protocol GetMoviesPageUseCase {
    func execute(page: Int) async throws -> MoviesPage
}
