//
//  PhotoRepositoryProtocol.swift
//  Photostream
//
//  Created by Md Fahim Faez Abir on 5/9/25.
//

protocol PhotoRepositoryProtocol {
    func fetchPhotos(page: Int, limit: Int) async throws -> [PhotoModel]
}
