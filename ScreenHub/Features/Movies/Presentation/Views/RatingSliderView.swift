//
//  RatingSliderView.swift
//  ScreenHub
//
//  Created by Nemanja Ignjatovic on 4/17/26.
//

import SwiftUI

struct RatingSliderView: View {
    @Binding var value: Double

    private let range: ClosedRange<Double> = 0.0...10.0
    private let step: Double = 0.1

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            Text("Rating")
                .font(.headline)

            HStack(spacing: 12) {
                Slider(value: $value, in: range, step: step)

                TextField(
                    "",
                    value: $value,
                    format: .number.precision(.fractionLength(1))
                )
                .keyboardType(.decimalPad)
                .multilineTextAlignment(.center)
                .frame(width: 60)
                .textFieldStyle(.roundedBorder)
            }

            HStack {
                Text("0.0")
                Spacer()
                Text("10.0")
            }
            .font(.caption)
            .foregroundStyle(.secondary)
        }
        .padding()
        .onChange(of: value) { _, newValue in
            let clamped = min(max(newValue, range.lowerBound), range.upperBound)
            if clamped != newValue {
                value = clamped
            }
        }
    }
}
