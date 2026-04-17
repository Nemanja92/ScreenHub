//
//  FilterView.swift
//  ScreenHub
//
//  Created by Nemanja Ignjatovic on 4/17/26.
//

import SwiftUI

struct FilterView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var filter: MoviesFilter
    let onApply: () -> Void
    
    var body: some View {
        NavigationStack {
            RatingSliderView(value: $filter.minimumRating)
                .navigationTitle("Filters")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Apply", action: onApply)
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") {
                            dismiss()
                        }
                    }
                }
        }
    }
}
