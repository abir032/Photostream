//
//  PhotoGroupModel.swift
//  Photostream
//
//  Created by Md Fahim Faez Abir on 5/9/25.
//

struct PhotoGroup {
    enum GroupType {
        case single
        case triple
    }
    let type: GroupType
    let photos: [PhotoModel]
}
