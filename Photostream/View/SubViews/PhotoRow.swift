//
//  PhotoRow.swift
//  Photostream
//
//  Created by Md Fahim Faez Abir on 5/9/25.
//

import SwiftUI

struct PhotoRow: View {
    let photos: [PhotoModel]
    let layout: PhotoGroup.GroupType
    let onPhotoTap: (PhotoModel) -> Void
    
    private let spacing: CGFloat = 4
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: spacing) {
                switch layout {
                case .single:
                    if let photo = photos.first {
                        PhotoItem(
                            photo: photo,
                            width: geometry.size.width,
                            height: calculateSinglePhotoHeight(photo: photo, width: geometry.size.width),
                            onPhotoTap: onPhotoTap
                        )
                    }
                    
                case .triple:
                    ForEach(Array(photos.enumerated()), id: \.element.id) { index, photo in
                        let itemWidth = (geometry.size.width - spacing * 2) / 3
                        PhotoItem(
                            photo: photo,
                            width: itemWidth,
                            height: itemWidth * 1.2,
                            onPhotoTap: onPhotoTap
                        )
                    }
                    
                    ForEach(photos.count..<3, id: \.self) { _ in
                        let itemWidth = (geometry.size.width - spacing * 2) / 3
                        Rectangle()
                            .fill(Color.clear)
                            .frame(width: itemWidth, height: itemWidth * 1.2)
                    }
                }
            }
        }
        .frame(height: calculateRowHeight(geometry: nil))
    }
    
    private func calculateSinglePhotoHeight(photo: PhotoModel, width: CGFloat) -> CGFloat {
        let aspectRatio = CGFloat(photo.height) / CGFloat(photo.width)
        let calculatedHeight = width * aspectRatio
        return min(max(calculatedHeight, 200), 400)
    }
    
    private func calculateRowHeight(geometry: GeometryProxy?) -> CGFloat {
        switch layout {
        case .single:
            if let photo = photos.first {
                let width = UIScreen.main.bounds.width - 16
                return calculateSinglePhotoHeight(photo: photo, width: width) + 50
            }
            return 250
            
        case .triple:
            let width = UIScreen.main.bounds.width - 16
            let itemWidth = (width - spacing * 2) / 3
            return itemWidth * 1.2 + 50
        }
    }
}
