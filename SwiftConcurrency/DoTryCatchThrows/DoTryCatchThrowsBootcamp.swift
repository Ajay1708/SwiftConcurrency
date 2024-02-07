//
//  DoTryCatchThrowsBootcamp.swift
//  SwiftConcurrency
//
//  Created by Venkata Ajay Sai Nellori on 06/02/24.
//

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

class DoTryCatchThrowsManager {
    let isActive: Bool = true
    func getTitle1() -> String? {
        if isActive {
            return "NEW TEXT 1"
        } else {
            return nil
        }
    }
    
    func getTitle2() -> (title: String?, error: Error?) {
        if isActive {
            return ("NEW TEXT 2", nil)
        } else {
            return (nil, URLError.init(URLError.Code.badURL))
        }
    }
    
    func getTitle3() -> Result<String, Error> {
        if isActive {
            return .success("NEW TEXT 3")
        } else {
            return .failure(URLError.init(.badServerResponse))
        }
    }
    
    func getTitle4() throws -> String {
        throw URLError(.appTransportSecurityRequiresSecureConnection)
    }
    
    func getTitle5() throws -> String {
        if isActive {
            return "NEW TEXT 5"
        } else {
            throw URLError(.backgroundSessionInUseByAnotherProcess)
        }
    }
}
struct DoTryCatchThrowsBootcamp: View {
    @StateObject var viewModel = DoTryCatchThrowsViewModel(manager: DoTryCatchThrowsManager())
    var body: some View {
        Text(viewModel.text)
            .frame(width: 300, height: 300)
            .background(Color.blue)
            .onTapGesture {
                viewModel.fetchTitle()
            }
    }
}

#Preview {
    DoTryCatchThrowsBootcamp()
}
