//
//  SearchMovieUseCaseImpl.swift
//  ScreenHub
//
//  Created by Nemanja Ignjatovic on 4/16/26.
//

import Foundation
struct SearchMovieUseCaseImpl : SearchMovieUseCase {
    func execute(movies: [Movie], query: String) -> [Movie] {
        movies.search(query: query, by: \.title)
    }
}

extension Array {
    func search(
        query: String,
        by keyPath: KeyPath<Element, String>
    ) -> [Element] {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return self }

        return filter {
            $0[keyPath: keyPath]
                .localizedStandardContains(trimmed)
        }
    }
}
