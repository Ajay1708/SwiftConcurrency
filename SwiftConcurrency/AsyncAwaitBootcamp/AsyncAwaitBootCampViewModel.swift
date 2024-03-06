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
        try? await Task.sleep(nanoseconds: 2_000_000_000) // Sleep is an async function so we need to await for suspending the current task for atleast the given duration in seconds
        dataArray.append("Author2 : \(Thread.current)")
        
    }
}
