//
//  APIService.swift
//  Photostream
//
//  Created by Md Fahim Faez Abir on 4/9/25.
//

import Foundation


class APIService {
    static let shared = APIService()
    private let networkMonitor = NetworkMonitor.shared
    private let cache = NSCache<NSString, NSData>()
    private var session = URLSession.shared
    
    private init() {
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .useProtocolCachePolicy
        URLCache.shared = URLCache(
            memoryCapacity: 50_000_000,
            diskCapacity: 200_000_000,
            diskPath: "APIServiceCache"
        )
        configuration.urlCache = URLCache.shared
        self.session = URLSession(configuration: configuration)
    }
    
    func fetchData<T: Codable>(from urlString: String) async throws -> T {
        guard await networkMonitor.checkNetworkConnection() else {
            return try fetchFromCache(for: urlString)
        }
        
        guard let url = URL(string: urlString) else {
            throw AppError.invalidURL
        }
        
        if let cachedResult: T = try? fetchFromCache(for: urlString) {
            debugPrint("!1001: Returning cached result")
            return cachedResult
        }
        
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw AppError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw AppError.serverError(statusCode: httpResponse.statusCode)
        }
        
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(T.self, from: data)
            saveToCache(data: data, for: urlString)
            return result
        } catch {
            throw AppError.decodingError
        }
    }
    
    private func saveToCache(data: Data, for urlString: String) {
        cache.setObject(data as NSData, forKey: urlString as NSString)
    }
    
    private func fetchFromCache<T: Codable>(for urlString: String) throws -> T {
        guard let cachedData = cache.object(forKey: urlString as NSString) as Data? else {
            throw AppError.noData
        }
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: cachedData)
        } catch {
            throw AppError.decodingError
        }
    }
}
