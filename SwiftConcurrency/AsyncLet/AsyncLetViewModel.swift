//
//  AsyncLetViewModel.swift
//  SwiftConcurrency
//
//  Created by Venkata Ajay Sai Nellori on 03/03/24.
//

import Foundation
import SwiftUI

class AsyncLetViewModel: ObservableObject {
    var imageDownloader: ImageDownloader
    init() {
        self.imageDownloader = ImageDownloader()
    }
    
    @MainActor func fetchImage1() async throws -> UIImage? {
        return try await imageDownloader.downloadWithAsync()
    }
}
