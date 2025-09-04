//
//  PhotoDTO.swift
//  Photostream
//
//  Created by Md Fahim Faez Abir on 4/9/25.
//

import Foundation

struct PicsumPhotoDTO: Codable, Identifiable {
    let id: String?
    let author: String?
    let width: Int?
    let height: Int?
    let url: String?
    let downloadUrl: String?

    enum CodingKeys: String, CodingKey {
        case id
        case author
        case width
        case height
        case url
        case downloadUrl = "download_url"
    }
}
