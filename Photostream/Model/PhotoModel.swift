//
//  PhotoModel.swift
//  Photostream
//
//  Created by Md Fahim Faez Abir on 4/9/25.
//

import Foundation

struct PhotoModel: Identifiable, Equatable {
    let id: String
    let author: String
    let width: Int
    let height: Int
    let url: URL?
    let downloadUrl: URL?
    var visitedCount: Int = 0
    
    init?(from dto: PicsumPhotoDTO) {
        self.id = dto.id ?? ""
        self.author = dto.author ?? ""
        self.width = dto.width ?? 0
        self.height = dto.height ?? 0
        self.url = URL(string: dto.url ?? "")
        self.downloadUrl = URL(string: dto.downloadUrl ?? "")
    }
}
