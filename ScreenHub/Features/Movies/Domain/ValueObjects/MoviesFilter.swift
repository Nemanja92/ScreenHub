//
//  MoviesFilter.swift
//  ScreenHub
//
//  Created by Nemanja Ignjatovic on 4/17/26.
//

struct MoviesFilter: Equatable {
    var minimumRating: Double

    init(minimumRating: Double = 0) {
        self.minimumRating = minimumRating
    }
}
