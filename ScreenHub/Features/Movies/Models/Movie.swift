//
//  Movie.swift
//  ScreenHub
//
//  Created by Nemanja Ignjatovic on 1/26/26.
//

import Foundation

struct Movie: Decodable, Identifiable, Equatable {
    let id: String
    let title: String
    let year: Int
    let runtimeMinutes: Int
    let genres: [String]
    let plot: String
    let posterUrl: String
    let trailerUrl: String
    let rating: Double
    let directors: [String]
    let cast: [String]
    let releaseDate: String
}
