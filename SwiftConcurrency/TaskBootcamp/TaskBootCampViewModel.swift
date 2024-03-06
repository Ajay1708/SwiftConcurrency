//
//  TaskBootCampViewModel.swift
//  SwiftConcurrency
//
//  Created by Venkata Ajay Sai Nellori on 12/02/24.
//

import Foundation
import SwiftUI
class TaskBootCampViewModel: ObservableObject {
    @Published var image1: UIImage?
    @Published var image2: UIImage?
    
    var imageDownloader: ImageDownloader
    init() {
        self.imageDownloader = ImageDownloader()
    }
    
    @MainActor func fetchImage1() async {
        image1 = try? await imageDownloader.downloadWithAsync()
    }
    @MainActor func fetchImage2() async {
        image2 = try? await imageDownloader.downloadWithAsync()
    }
}
