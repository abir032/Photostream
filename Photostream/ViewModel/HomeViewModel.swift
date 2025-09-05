//
//  HomeViewModel.swift
//  Photostream
//
//  Created by Md Fahim Faez Abir on 5/9/25.
//


import Foundation
import SwiftUI

@MainActor
final class HomeViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var photos: [PhotoModel] = []
    @Published var isLoading = false
    @Published var isLoadingMore = false
    @Published var errorMessage: String?
    @Published var showError = false
    
    // MARK: - Private Properties
    private let repository: PhotoRepositoryProtocol
    private var currentPage = 1
    private var hasMorePages = true
    private let pageLimit = 20
    
    // MARK: - Initialization
    init(repository: PhotoRepositoryProtocol = PhotoRepositoryImpl()) {
        self.repository = repository
    }
    
    func loadPhotos() async {
        guard !isLoading else { return }
        resetPaginationState()
        isLoading = true
        errorMessage = nil
        showError = false
        
        do {
            let newPhotos = try await repository.fetchPhotos(page: currentPage, limit: pageLimit)
            photos = newPhotos
            updatePaginationState(with: newPhotos)
        } catch {
            errorMessage = AppError.handleError(error)
            showError = true
        }
        
        isLoading = false
    }
    
    func loadMorePhotos() async {
        guard !isLoadingMore && !isLoading && hasMorePages else { return }
        
        isLoadingMore = true
        
        do {
            let nextPage = currentPage + 1
            let newPhotos = try await repository.fetchPhotos(page: nextPage, limit: pageLimit)
            
            if !newPhotos.isEmpty {
                photos.append(contentsOf: newPhotos)
                currentPage = nextPage
                updatePaginationState(with: newPhotos)
            } else {
                hasMorePages = false
            }
        } catch {
            errorMessage = AppError.handleError(error)
            showError = true
        }
        
        isLoadingMore = false
    }
    
    func refreshPhotos() async {
        photos.removeAll()
        resetPaginationState()
        await loadPhotos()
    }
    
    func shouldLoadMore(currentPhoto: PhotoModel) -> Bool {
        guard let currentIndex = photos.firstIndex(where: { $0.id == currentPhoto.id }) else {
            return false
        }
        let remainingPhotos = photos.count - currentIndex
        return remainingPhotos <= 5 && hasMorePages && !isLoadingMore && !isLoading
    }
    
    func retry() async {
        if photos.isEmpty {
            await loadPhotos()
        } else {
            await loadMorePhotos()
        }
    }
    
    private func resetPaginationState() {
        currentPage = 1
        hasMorePages = true
    }
    
    private func updatePaginationState(with newPhotos: [PhotoModel]) {
        if newPhotos.count < pageLimit {
            hasMorePages = false
        }
    }
}
