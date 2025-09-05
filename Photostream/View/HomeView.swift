//
//  HomeView.swift
//  Photostream
//
//  Created by Md Fahim Faez Abir on 5/9/25.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var selectedPhoto: PhotoModel?
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemBackground)
                    .ignoresSafeArea()
                
                if viewModel.isLoading && viewModel.photos.isEmpty {
                    LoadingSkeletonGrid()
                } else if viewModel.photos.isEmpty && !viewModel.isLoading {
                    EmptyStateView {
                        await viewModel.loadPhotos()
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: 8) {
                            CustomPhotoGrid(photos: viewModel.photos) { photo in
                                selectedPhoto = photo
                            } onLoadMore: { photo in
                                if viewModel.shouldLoadMore(currentPhoto: photo) {
                                    Task {
                                        await viewModel.loadMorePhotos()
                                    }
                                }
                            }
                            
                            if viewModel.isLoadingMore {
                                LoadingMoreView()
                                    .padding(.vertical)
                            }
                        }
                        .padding(.horizontal, 8)
                    }
                    .refreshable {
                        await viewModel.refreshPhotos()
                    }
                }
            }
            .navigationTitle("Photos")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if viewModel.isLoading {
                        ProgressView()
                            .scaleEffect(0.8)
                    }
                }
            }
            .sheet(item: $selectedPhoto) { photo in
                PhotoDetailView(photo: photo)
            }
            .alert("Error", isPresented: $viewModel.showError) {
                Button("Retry") {
                    Task {
                        await viewModel.retry()
                    }
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text(viewModel.errorMessage ?? "An unexpected error occurred")
            }
        }
        .task {
            if viewModel.photos.isEmpty {
                await viewModel.loadPhotos()
            }
        }
    }
}
