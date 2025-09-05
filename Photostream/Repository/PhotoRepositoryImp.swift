//
//  PhotoRepositoryImplementation.swift
//  Photostream
//
//  Created by Md Fahim Faez Abir on 5/9/25.
//

final class PhotoRepositoryImpl: PhotoRepositoryProtocol {
    
    func fetchPhotos(page: Int, limit: Int) async throws -> [PhotoModel] {
        do {
            guard let base_url = Configuration.apiBaseURL else {
                throw AppError.invalidURL
            }
            let url = base_url + Constants.API.endpointList + "?\(Constants.API.querryParamPageKey)=\(page)&\(Constants.API.querryParamLimitKey)=\(limit)"
            let result: [PicsumPhotoDTO] = try await APIService.shared.fetchData(from: url)
            //dump(result)
            let photoModels: [PhotoModel] = result.compactMap { dto in
                PhotoModel(from: dto)
            }
            
            return photoModels
        } catch {
            throw error
        }
    }
}
