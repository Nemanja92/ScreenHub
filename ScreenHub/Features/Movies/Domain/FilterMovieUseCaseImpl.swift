//
//  FilterMovieUseCaseImpl.swift
//  ScreenHub
//
//  Created by Nemanja Ignjatovic on 4/17/26.
//

struct FilterMovieUseCaseImpl: FilterMovieUseCase {
    func execute(movies: [Movie], filter: MoviesFilter) -> [Movie] {
        guard filter.minimumRating > 0 else { return movies }

        return movies.filter { movie in
            movie.rating >= filter.minimumRating
        }
    }
}
