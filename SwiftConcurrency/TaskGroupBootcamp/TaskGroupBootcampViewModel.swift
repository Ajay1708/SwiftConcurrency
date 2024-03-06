//
//  TaskGroupBootcampViewModel.swift
//  SwiftConcurrency
//
//  Created by Venkata Ajay Sai Nellori on 06/03/24.
//

import Foundation
import UIKit

class TaskGroupBootcampViewModel: ObservableObject {
    @Published var images: [UIImage] = []
    let manager: TaskGroupBootCampManager
    init() {
        self.manager = TaskGroupBootCampManager()
    }
    
    func fetchImagesWithAsyncLet() async {
        async let fetchImage1 = manager.imageDownloader.downloadWithAsync()
        async let fetchImage2 = manager.imageDownloader.downloadWithAsync()
        async let fetchImage3 = manager.imageDownloader.downloadWithAsync()
        async let fetchImage4 = manager.imageDownloader.downloadWithAsync()
        
        let (image1,image2,image3,image4) = await(try? fetchImage1, try? fetchImage2, try? fetchImage3, try? fetchImage4)
        if let image1, let image2, let image3, let image4 {
            images.append(contentsOf: [image1,image2,image3,image4])
        }
    }
    
    func fetchImagesWithAsyncGroup() async {
        do {
            self.images = try await manager.fetchImagesWithTaskGroup()
        } catch {
            
        }
    }
        
}

class TaskGroupBootCampManager {
    let imageDownloader: ImageDownloader
    init() {
        imageDownloader = ImageDownloader()
    }
    func fetchImagesWithTaskGroup() async throws -> [UIImage] {
        let imageUrls = [
            "https://picsum.photos/200",
            "https://picsum.photos/200",
            "https://picsum.photos/200"
        ]
        return try await withThrowingTaskGroup(of: UIImage?.self) { group in
            var images: [UIImage] = []
            // If you are adding a known number of elements to an array, use reserveCapacity method to avoid multiple reallocations.
            images.reserveCapacity(images.count)
            for url in imageUrls {
                // Adds a child task to the group
                // Each child task inherits the meta data from parent Task in which we are calling this method
                // For example if the parent task has a high priority then all the child tasks will have high priority unless we pass custom priority explicity like group.addTask(priority: .background, operation: {// Async work})
                group.addTask {
                    // If one child task throws an error resulting in cancelling the group, and all of its child tasks
                    // If 49 fetch calls got successful and the last fetch call throws an error resulting in throwing an error event though 49 other calls got successful. Hence use option try
                    try? await self.imageDownloader.downloadWithAsync(from: url)
                    //try await self.imageDownloader.downloadWithAsync(from: url)
                }
            }
            
            // To collect the results of the group’s child tasks, you can use a for-await-in loop
            for try await taskResult in group {
                if let image = taskResult {
                    images.append(image)
                }
            }
            return images
        }
    }
}
