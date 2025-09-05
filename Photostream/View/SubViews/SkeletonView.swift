//
//  SkeletonView.swift
//  Photostream
//
//  Created by Md Fahim Faez Abir on 5/9/25.
//

import SwiftUI

// MARK: - Loading Skeleton Grid
struct LoadingSkeletonGrid: View {
    private let spacing: CGFloat = 8
    
    var body: some View {
        LazyVStack(spacing: spacing) {
            ForEach(0..<4, id: \.self) { groupIndex in
                if groupIndex == 0 {
                    SkeletonPhotoRow(layout: .single)
                } else {
                    SkeletonPhotoRow(layout: .triple)
                }
            }
        }
        .padding(.horizontal, 8)
    }
}

// MARK: - Skeleton Photo Row
struct SkeletonPhotoRow: View {
    let layout: PhotoGroup.GroupType
    private let spacing: CGFloat = 4

    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: spacing) {
                switch layout {
                case .single:
                    SkeletonPhotoItem(
                        width: geometry.size.width,
                        height: 250
                    )
                    
                case .triple:
                    ForEach(0..<3, id: \.self) { _ in
                        let itemWidth = (geometry.size.width - spacing * 2) / 3
                        SkeletonPhotoItem(
                            width: itemWidth,
                            height: itemWidth * 1.2
                        )
                    }
                }
            }
        }
        .frame(height: layout == .single ? 300 : calculateTripleHeight())
    }

    private func calculateTripleHeight() -> CGFloat {
        let width = UIScreen.main.bounds.width - 16
        let itemWidth = (width - spacing * 2) / 3
        return itemWidth * 1.2 + 50
    }
}

// MARK: - Skeleton Photo Item
struct SkeletonPhotoItem: View {
    let width: CGFloat
    let height: CGFloat

    var body: some View {
        VStack(spacing: 0) {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.gray.opacity(0.2))
                .frame(width: width, height: height)
                .shimmer()
            HStack {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 60, height: 12)
                    .cornerRadius(6)
                    .shimmer()
                Spacer()
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 6)
            .frame(width: width)
        }
        .background(Color(.systemBackground))
        .cornerRadius(8)
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
}

// MARK: - Loading More View
struct LoadingMoreView: View {
    var body: some View {
        HStack {
            ProgressView()
                .scaleEffect(0.8)
            Text("Loading more photos...")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(height: 50)
    }
}

// MARK: - Empty State View
struct EmptyStateView: View {
    let onRetry: () async -> Void

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "photo.stack")
                .font(.system(size: 48))
                .foregroundColor(.secondary)
            
            Text("No Photos Yet")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Pull down to refresh or tap retry to load photos")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button("Retry") {
                Task {
                    await onRetry()
                }
            }
            .buttonStyle(.borderedProminent)
        }
    }
}
