//
//  AsyncAwaitBootCamp.swift
//  SwiftConcurrency
//
//  Created by Venkata Ajay Sai Nellori on 11/02/24.
//

import SwiftUI

struct AsyncAwaitBootCamp: View {
    @StateObject var vm = AsyncAwaitBootCampViewModel()
    @State private var addAuthorState: Task<(), Never>? = nil
    var body: some View {
        List(vm.dataArray, id: \.self) { item in
            Text(item)
        }
        .onAppear {
            vm.addTitle1()
            vm.addTitle2()
            addAuthorState = Task {
                await vm.addAuthor1()
                //Just because we are awaiting something doesn't necessarily mean we are going onto a background thread
                // Await is just a suspension point in the task we are awaiting the returned result
                // So it is always best to explicitly use MainActor to switch to main thread before updating UI
            }
            let finalText = "FINAL TEXT: \(Thread.current)"
            vm.dataArray.append(finalText)
        }
        .onDisappear {
            addAuthorState?.cancel()
        }
    }
}

#Preview {
    AsyncAwaitBootCamp()
}
