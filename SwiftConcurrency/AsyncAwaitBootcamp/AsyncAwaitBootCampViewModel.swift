//
//  AsyncAwaitBootCampViewModel.swift
//  SwiftConcurrency
//
//  Created by Venkata Ajay Sai Nellori on 11/02/24.
//

import Foundation
import SwiftUI
class AsyncAwaitBootCampViewModel: ObservableObject {
    @Published var dataArray: [String] = []
    
    func addTitle1() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            guard let self = self else {return}
            self.dataArray.append("Title1 : \(Thread.current)")
        }
    }
    
    func addTitle2() {
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) { [weak self] in
            guard let self = self else {return}
            let title2 = "Title2 : \(Thread.current)"
            DispatchQueue.main.async {
                self.dataArray.append(title2)
                let title3 = "Title3 : \(Thread.current)"
                self.dataArray.append(title3)
            }
        }
    }
    
    @MainActor func addAuthor1() async {
        let author1 = "Author1 : \(Thread.current)"
        dataArray.append(author1)
        try? await Task.sleep(nanoseconds: 2_000_000_000) // Task.sleep executes in background thread so the immediate line will also execute in background thread. So we need to explicitly execute the below line in main thread because we are updaing UI.
        dataArray.append("Author2 : \(Thread.current)")
        
    }
    //Just because we are awaiting something doesn't necessarily mean we are going onto a background thread
    // Await is just a suspension point in the task we are awaiting the returned result
    // So it is always best to explicitly use MainActor to switch to main thread before updating UI
}
