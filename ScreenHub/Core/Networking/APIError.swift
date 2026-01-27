//
//  APIError.swift
//  ScreenHub
//
//  Created by Nemanja Ignjatovic on 1/26/26.
//

import Foundation

enum APIError: Error, LocalizedError, Equatable {

    case invalidURL
    case invalidResponse
    case httpStatus(code: Int)
    case decodingFailed
    case requestFailed(underlying: String)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL."
        case .invalidResponse:
            return "Invalid server response."
        case .httpStatus(let code):
            return "Request failed with HTTP status code \(code)."
        case .decodingFailed:
            return "Failed to decode the server response."
        case .requestFailed(let underlying):
            return "Request failed. \(underlying)"
        }
    }
}
