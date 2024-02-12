//
//  DoTryCatchThrowsViewModel.swift
//  SwiftConcurrency
//
//  Created by Venkata Ajay Sai Nellori on 11/02/24.
//

import Foundation
import SwiftUI

class DoTryCatchThrowsViewModel: ObservableObject {
    @Published var text: String = "Starting text."
    var manager: DoTryCatchThrowsManager
    init(manager: DoTryCatchThrowsManager) {
        self.manager = manager
    }
    func fetchTitle() {
        /*
         if let title = manager.getTitle1() {
         self.text = title
         }*/
        
        /*
         if let title = manager.getTitle2().title {
         self.text = title
         } else if let error = manager.getTitle2().error?.localizedDescription {
         self.text = error
         }*/
        
        /*
         let result = manager.getTitle3()
         switch result {
         case .success(let success):
         self.text = success
         case .failure(let failure):
         self.text = failure.localizedDescription
         }*/
        
        /*do {
         let title =  try manager.getTitle4() // When you try if the getTitle4 method throws an error the program control will move to catch block
         self.text = title
         } catch {
         self.text = error.localizedDescription
         }*/
        
        do {
            // If you want to use multiple throwable functions then use try? which will not move the program control to catch block incase of error.
            if let title = try? manager.getTitle4() {
                text = title
            }
            let title = try manager.getTitle5()
            text = title
        } catch {
            text = error.localizedDescription
        }
    }
}
