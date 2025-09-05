
//
//  PhotoItem.swift
//  Photostream
//
//  Created by Md Fahim Faez Abir on 5/9/25.
//

import SwiftUI

// MARK: - Photo Item
struct PhotoItem: View {
    let photo: PhotoModel
    let width: CGFloat
    let height: CGFloat
    let onPhotoTap: (PhotoModel) -> Void

    var body: some View {
        VStack(spacing: 0) {
            AsyncImage(url: photo.downloadUrl) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: width, height: height)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        
                case .failure(_):
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: width, height: height)
                        .overlay(
                            Image(systemName: "photo")
                                .foregroundColor(.gray)
                        )
                        
                case .empty:
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: width, height: height)
                        .shimmer()
                        
                @unknown default:
                    EmptyView()
                }
            }
            // Author label
            HStack {
                Text(photo.author)
                    .font(.caption)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                Spacer()
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 6)
            .frame(width: width)
            .background(Color(.systemBackground))
        }
        .background(Color(.systemBackground))
        .cornerRadius(8)
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
        .onTapGesture {
            onPhotoTap(photo)
        }
    }
}
