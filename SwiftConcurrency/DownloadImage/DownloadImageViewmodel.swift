//
//  DownloadImageViewmodel.swift
//  SwiftConcurrency
//
//  Created by Venkata Ajay Sai Nellori on 11/02/24.
//

import Foundation
import SwiftUI
import Combine

class DownloadImageViewModel: ObservableObject {
    @Published var image: Image? = nil
    @Published var cancellables: Set<AnyCancellable> = []
    var downloader: ImageDownloader
    init() {
        self.downloader = ImageDownloader()
    }
    
    func fetchCompletionImage() {
        downloader.downloadWithEscaping { [weak self] image, err in
            guard let self = self else {return}
            if let image = image {
                DispatchQueue.main.async {
                    self.image = Image(uiImage: image)
                }
            }
        }
    }
    func fetchCombineImage() {
        downloader.downloadWithCombine()
            .receive(on: DispatchQueue.main)
            .sink { _ in
            } receiveValue: { [weak self] image in
                guard let self = self else {return}
                if let image = image {
                    self.image = Image(uiImage: image)
                }
            }
            .store(in: &cancellables)
    }
    func fetchAsyncImage() async {
        if let image = try? await downloader.downloadWithAsync() {
            await MainActor.run {
                self.image = Image(uiImage: image)
            }
        }
    }
}
