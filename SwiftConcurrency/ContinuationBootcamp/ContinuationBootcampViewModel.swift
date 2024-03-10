//
//  ContinuationBootcampViewModel.swift
//  SwiftConcurrency
//
//  Created by Venkata Ajay Sai Nellori on 10/03/24.
//

import Foundation
import UIKit

class ContinuationBootcampViewModel: ObservableObject {
    @Published var image: UIImage?
    let manager: ContinuationBootCampManager
    init() {
        manager = ContinuationBootCampManager()
    }
    
    func fetchImage() async {
        do {
            let data = try await manager.getData(from: "https://picsum.photos/300")
            if let image = UIImage(data: data) {
                await MainActor.run {
                    self.image = image
                }
            }
        } catch {
            print(error)
        }
    }
}
