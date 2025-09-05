//
//  AppError.swift
//  Photostream
//
//  Created by Md Fahim Faez Abir on 4/9/25.
//

import Foundation

enum AppError: Error, LocalizedError {
    case missingKeyError(key: String)
    case networkError
    case invalidURL
    case invalidResponse
    case serverError(statusCode: Int)
    case decodingError
    case encodingError
    case noData
    
    var errorDescription: String? {
        switch self {
        case .missingKeyError(key: let key):
            return "Missing or invalid value for key: '\(key)' in Info.plist"
        case .networkError:
            return "Network error occurred: No internet connection available"
        case .invalidURL:
            return "Invalid URL provided"
        case .invalidResponse:
            return "Invalid response from server"
        case .serverError(let statusCode):
            return "Server error with status code: \(statusCode)"
        case .decodingError:
            return "Error decoding response"
        case .encodingError:
            return "Error encoding request data"
        case .noData:
            return "No data received from server"
        }
    }
    
    static func handleError(_ error: Error) -> String {
        if let appError = error as? AppError {
            switch appError {
            case .networkError:
                return "No internet connection. Please check your network and try again."
            case .serverError(let statusCode):
                return "Temporary server issue. Please try again in a moment."
            default:
                return "Something went wrong. Please try again."
            }
        } else {
            return "Something went wrong. Please try again."
        }
    }
}
