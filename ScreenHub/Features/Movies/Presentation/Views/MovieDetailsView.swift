//
//  MovieDetailsView.swift
//  ScreenHub
//
//  Created by Nemanja Ignjatovic on 1/26/26.
//

import SwiftUI

struct MovieDetailsView: View {

    let movie: Movie

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                AsyncImage(url: movie.posterUrl) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    Color.gray.opacity(0.3)
                        .frame(height: 300)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text(movie.title)
                        .font(.title)
                        .fontWeight(.bold)

                    Text("\(movie.year) • \(movie.runtimeMinutes) min")
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    Text(String(format: "%.1f ★", movie.rating))
                        .font(.subheadline)

                    Text(movie.plot)
                        .font(.body)
                        .padding(.top, 8)

                    if !movie.directors.isEmpty {
                        Text("Director: \(movie.directors.joined(separator: ", "))")
                            .font(.subheadline)
                            .padding(.top, 8)
                    }

                    if !movie.cast.isEmpty {
                        Text("Cast: \(movie.cast.joined(separator: ", "))")
                            .font(.subheadline)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}
