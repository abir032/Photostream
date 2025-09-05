//
//  PhotoDetailView.swift
//  Photostream
//
//  Created by Md Fahim Faez Abir on 5/9/25.
//

import SwiftUI

// MARK: - Photo Detail View
struct PhotoDetailView: View {
    let photo: PhotoModel
    @Environment(\.dismiss) private var dismiss
    
    //Download status
    @State private var showDownloadAlert = false
    @State private var downloadStatus: DownloadStatus = .none
    
    enum DownloadStatus {
        case none
        case success
        case failure(Error)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                
                AsyncImage(url: photo.downloadUrl) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    ProgressView()
                        .tint(.white)
                }
            }
            .navigationTitle(photo.author)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 17, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        //Download image
                        downloadImage()
                    } label: {
                        Image(systemName: "square.and.arrow.down")
                            .font(.system(size: 17, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
            }
            .toolbarBackground(.hidden, for: .navigationBar)
            .alert(isPresented: $showDownloadAlert) {
                switch downloadStatus {
                case .success:
                    Alert(
                        title: Text("Success"),
                        message: Text("Image saved to your photos"),
                        dismissButton: .default(Text("OK"))
                    )
                case .failure(let error):
                    Alert(
                        title: Text("Error"),
                        message: Text(error.localizedDescription),
                        dismissButton: .default(Text("OK"))
                    )
                case .none:
                    Alert(title: Text(""))
                }
            }
        }
    }
    
    private func downloadImage() {
        guard let url = photo.downloadUrl else { return }
        
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                if let uiImage = UIImage(data: data) {
                    UIImageWriteToSavedPhotosAlbum(uiImage, nil, nil, nil)
                    DispatchQueue.main.async {
                        downloadStatus = .success
                        showDownloadAlert = true
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    downloadStatus = .failure(error)
                    showDownloadAlert = true
                }
            }
        }
    }
}
