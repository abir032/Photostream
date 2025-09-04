//
//  AppError.swift
//  Photostream
//
//  Created by Md Fahim Faez Abir on 4/9/25.
//

import Foundation

enum AppError: Error, LocalizedError {
    case missingKeyError(key : String)
    var errorDescription: String? {
        switch self {
        case .missingKeyError(key: let key):
            return "Missing or invalid value for key: '\(key)' in Info.plist"
        }
    }
}
