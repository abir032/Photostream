//
//  CustomPhotoGrid.swift
//  Photostream
//
//  Created by Md Fahim Faez Abir on 5/9/25.
//

import SwiftUI

// MARK: - Custom Photo Grid
struct CustomPhotoGrid: View {
    
    let photos: [PhotoModel]
    let onPhotoTap: (PhotoModel) -> Void
    let onLoadMore: (PhotoModel) -> Void
    
    private let spacing: CGFloat = 8
    
    var body: some View {
        LazyVStack(spacing: spacing) {
            ForEach(Array(groupedPhotos.enumerated()), id: \.offset) { index, group in
                switch group.type {
                case .single:
                    if let photo = group.photos.first {
                        PhotoRow(photos: [photo], layout: .single, onPhotoTap: onPhotoTap)
                            .onAppear {
                                onLoadMore(photo)
                            }
                    }
                case .triple:
                    PhotoRow(photos: group.photos, layout: .triple, onPhotoTap: onPhotoTap)
                        .onAppear {
                            if let lastPhoto = group.photos.last {
                                onLoadMore(lastPhoto)
                            }
                        }
                }
            }
        }
    }
    
    private var groupedPhotos: [PhotoGroup] {
        var groups: [PhotoGroup] = []
        var index = 0
        
        while index < photos.count {
            let groupIndex = groups.count
            
            if groupIndex % 4 == 0 {
                groups.append(PhotoGroup(type: .single, photos: [photos[index]]))
                index += 1
            } else {
                let endIndex = min(index + 3, photos.count)
                let groupPhotos = Array(photos[index..<endIndex])
                groups.append(PhotoGroup(type: .triple, photos: groupPhotos))
                index = endIndex
            }
        }
        
        return groups
    }
}
