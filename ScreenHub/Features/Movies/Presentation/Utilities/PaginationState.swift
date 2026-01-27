//
//  PaginationState.swift
//  ScreenHub
//
//  Created by Nemanja Ignjatovic on 1/26/26.
//

import Foundation

struct PaginationState {
    var currentPage: Int = 0
    var hasMore: Bool = true
    var isLoading: Bool = false

    mutating func startLoadingNextPage() {
        isLoading = true
    }

    mutating func finishLoading(page: Int, hasMore: Bool) {
        currentPage = page
        self.hasMore = hasMore
        isLoading = false
    }

    mutating func reset() {
        currentPage = 0
        hasMore = true
        isLoading = false
    }
}
