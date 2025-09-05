
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
    @State var imageLoadingState: ImageLoadingState = .empty

    var body: some View {
        VStack(spacing: 0) {
            switch imageLoadingState {
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
        }.onAppear {
            Task {
               let cachedImage = CachedImage(url: photo.downloadUrl)
               imageLoadingState = await cachedImage.load()
            }
        }.onDisappear {
            Task {
                await Task.yield()
            }
        }
    }
}

enum ImageLoadingState {
    case empty
    case success(Image)
    case failure(Error)
}

class ImageCache {
    static let shared = ImageCache()
    private let cache: NSCache<NSString, UIImage>

    private init() {
        cache = NSCache<NSString, UIImage>()
        cache.countLimit = 100
        cache.totalCostLimit = 1024 * 1024 * 100
    }

    func set(_ image: UIImage, for key: String) {
        cache.setObject(image, forKey: key as NSString)
    }

    func get(_ key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
}


struct CachedImage {
    private let url: URL?
    @MainActor private let cache = ImageCache.shared

    init(url: URL?) {
        self.url = url
    }

    func load() async -> ImageLoadingState {
        guard let url = url else {
            return .failure(URLError(.badURL))
        }

        if let cachedImage = await cache.get(url.absoluteString) {
            return .success(Image(uiImage: cachedImage))
        }

        let request = URLRequest(url: url)
        if let cachedResponse = URLCache.shared.cachedResponse(for: request),
           let uiImage = UIImage(data: cachedResponse.data) {
            await cache.set(uiImage, for: url.absoluteString)
            return .success(Image(uiImage: uiImage))
        }

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let uiImage = UIImage(data: data) else {
                return .failure(URLError(.cannotDecodeRawData))
            }
            await cache.set(uiImage, for: url.absoluteString)
            let cachedResponse = CachedURLResponse(
                response: response,
                data: data,
                userInfo: nil,
                storagePolicy: .allowed
            )
            URLCache.shared.storeCachedResponse(cachedResponse, for: request)
            return .success(Image(uiImage: uiImage))
        } catch {
            return .failure(error)
        }
    }
}
