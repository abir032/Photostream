//
//  Configuration.swift
//  Photostream
//
//  Created by Md Fahim Faez Abir on 4/9/25.
//

import Foundation

enum Configuration {
    private static func value(for key: String) throws -> String {
        guard let value = Bundle.main.object(forInfoDictionaryKey: key) as? String else {
            throw AppError.missingKeyError(key: key)
        }
        return value
    }
    
    static var apiBaseURL: String? {
        do {
            let baseUrl = try value(for: Constants.API.baseURlKey)
            return baseUrl
        } catch {
            debugPrint("Configuration Error: \(error.localizedDescription)")
            return nil
        }
    }
}
