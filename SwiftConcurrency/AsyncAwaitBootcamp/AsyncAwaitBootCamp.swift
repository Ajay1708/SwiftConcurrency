//
//  AsyncAwaitBootCamp.swift
//  SwiftConcurrency
//
//  Created by Venkata Ajay Sai Nellori on 11/02/24.
//

import SwiftUI

struct AsyncAwaitBootCamp: View {
    @StateObject var vm = AsyncAwaitBootCampViewModel()
    var body: some View {
        List(vm.dataArray, id: \.self) { item in
            Text(item)
        }
        .onAppear {
            vm.addTitle1()
            vm.addTitle2()
            Task {
                await vm.addAuthor1()
            }
            let finalText = "FINAL TEXT: \(Thread.current)"
            vm.dataArray.append(finalText)
        }
    }
}

#Preview {
    AsyncAwaitBootCamp()
}
