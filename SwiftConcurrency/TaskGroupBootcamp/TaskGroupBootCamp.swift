//
//  TaskGroupBootCampView.swift
//  SwiftConcurrency
//
//  Created by Venkata Ajay Sai Nellori on 06/03/24.
//

import SwiftUI

struct TaskGroupBootCamp: View {
    @StateObject var viewModel = TaskGroupBootcampViewModel()
    let gridItems: [GridItem] = [.init(.flexible()), .init(.flexible())]
    var body: some View {
        NavigationView {
            LazyVGrid(columns: gridItems) {
                ForEach(viewModel.images, id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 150)
                }
            }
            .navigationTitle("Async let")
        }
        .task {
            await viewModel.fetchImagesWithAsyncGroup()
        }
    }
}

#Preview {
    TaskGroupBootCamp()
}
