//
//  MoviesListView.swift
//  ScreenHub
//
//  Created by Nemanja Ignjatovic on 1/26/26.
//

import SwiftUI

struct MoviesListView: View {

    @StateObject private var viewModel: MoviesListViewModel

    init(viewModel: MoviesListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Movies")
        }
        .task {
            await viewModel.loadInitial()
        }
    }

    @ViewBuilder
    private var content: some View {
        if let message = viewModel.errorMessage {
            VStack(spacing: 12) {
                Text(message)
                    .multilineTextAlignment(.center)

                Button("Retry") {
                    Task { await viewModel.loadInitial() }
                }
            }
            .padding()
        } else {
            List {
                ForEach(viewModel.movies) { movie in
                    NavigationLink {
                        MovieDetailsView(movie: movie)
                    } label: {
                        MovieRowView(movie: movie)
                            .onAppear {
                                if movie.id == viewModel.movies.last?.id {
                                    Task { await viewModel.loadNextPage() }
                                }
                            }
                    }
                }

                if viewModel.isLoading {
                    HStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                }
            }
        }
    }
}
