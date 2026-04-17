//
//  FilterMovieUseCase.swift
//  ScreenHub
//
//  Created by Nemanja Ignjatovic on 4/17/26.
//

protocol FilterMovieUseCase {
    func execute(movies: [Movie], filter: MoviesFilter) -> [Movie]
}
