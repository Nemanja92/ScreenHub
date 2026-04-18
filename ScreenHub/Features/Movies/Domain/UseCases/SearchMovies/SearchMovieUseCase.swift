//
//  SearchMovieUseCase.swift
//  ScreenHub
//
//  Created by Nemanja Ignjatovic on 4/16/26.
//

protocol SearchMovieUseCase {
    func execute(movies: [Movie], query: String) -> [Movie]
}
