//
//  MoviesListView.swift
//  ScreenHub
//
//  Created by Nemanja Ignjatovic on 1/26/26.
//

import SwiftUI
import Observation

struct MoviesListView: View {
    
    @State private var viewModel: MoviesListViewModel
    
    init(viewModel: MoviesListViewModel) {
        _viewModel = State(initialValue: viewModel)
    }
    
    var body: some View {
        @Bindable var bindableViewModel = viewModel
        
        NavigationStack {
            content
                .navigationTitle("Movies")
                .searchable(text: $bindableViewModel.searchText, prompt: "Search movies")
        }
        .task {
            await viewModel.loadInitial()
        }
    }
    
    @ViewBuilder
    private var content: some View {
        switch viewModel.loadState {
        case .idle, .loading:
            loadingView
            
        case .failed(let message):
            errorView(message: message)
            
        case .loaded, .loadingNextPage:
            if shouldShowNoResults {
                noResultsView
            } else {
                moviesListView
            }
        }
    }
    
    private var loadingView: some View {
        ProgressView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func errorView(message: String) -> some View {
        VStack(spacing: 12) {
            Text(message)
                .multilineTextAlignment(.center)
            
            Button("Retry") {
                Task {
                    await viewModel.retryInitialLoad()
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var noResultsView: some View {
        VStack(spacing: 12) {
            Text("No results")
                .font(.headline)
            
            Text("No movies found for \"\(viewModel.searchText)\"")
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var moviesListView: some View {
        List {
            ForEach(viewModel.movies) { movie in
                NavigationLink {
                    MovieDetailsView(movie: movie)
                } label: {
                    MovieRowView(movie: movie)
                        .onAppear {
                            Task {
                                await viewModel.loadMoreIfNeeded(currentItem: movie)
                            }
                        }
                }
            }
            
            if viewModel.loadState == .loadingNextPage {
                HStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
                .padding(.vertical, 8)
                .listRowSeparator(.hidden)
            }
            
            if let message = viewModel.paginationErrorMessage {
                VStack(spacing: 8) {
                    Text(message)
                        .font(.footnote)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.secondary)
                    
                    Button("Try Again") {
                        Task {
                            await viewModel.retryLoadMore()
                        }
                    }
                    .buttonStyle(.borderless)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .listRowSeparator(.hidden)
            }
        }
    }
    
    private var shouldShowNoResults: Bool {
        let trimmedQuery = viewModel.searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        return viewModel.movies.isEmpty && !trimmedQuery.isEmpty
    }
}
