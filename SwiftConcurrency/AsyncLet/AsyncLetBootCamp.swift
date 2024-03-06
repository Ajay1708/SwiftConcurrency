//
//  AsyncLetBootCamp.swift
//  SwiftConcurrency
//
//  Created by Venkata Ajay Sai Nellori on 03/03/24.
//

import SwiftUI

/// Async let allows to perform multiple async methods at the same time and await for the result of all of those methods together.
/// Async let is great for executing multiple asynchronous functions at once  in a single task and then awaiting the result of all of those functions at the same time.
/// There are some limitations it's a lot of code it's not super scalable. You can use async let if you are making 2 to 3 fetch requests
struct AsyncLetBootCamp: View {
    @State var images: [UIImage] = []
    @State var task: Task<(), Never>?
    let gridItems: [GridItem] = [.init(.flexible()), .init(.flexible())]
    @StateObject var viewmodel = AsyncLetViewModel()
    var body: some View {
        NavigationView {
            LazyVGrid(columns: gridItems) {
                ForEach(images, id: \.self) { image in
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 150)
                }
            }
            .navigationTitle("Async let")
        }
        
        .onAppear {
            task = Task{
                
                async let fetchImage1 = viewmodel.fetchImage1()
                async let fetchImage2 = viewmodel.fetchImage1()
                async let fetchImage3 = viewmodel.fetchImage1()
                async let fetchImage4 = viewmodel.fetchImage1()
                
                do {
                    let (image1, image2, image3, image4) = await(try fetchImage1, try fetchImage2, try fetchImage3, try fetchImage4)
                    self.images.append(contentsOf: [image1!,image2!,image3!,image4!])
                } catch {
                    
                }
                
                /// The below code style executes async methods synchronously (one by one )
//                do {
//                    if let image1 = try await viewmodel.fetchImage1() {
//                        self.images.append(image1)
//                    }
//                    if let image2 = try await viewmodel.fetchImage1() {
//                        self.images.append(image2)
//                    }
//                    if let image3 = try await viewmodel.fetchImage1() {
//                        self.images.append(image3)
//                    }
//                    if let image4 = try await viewmodel.fetchImage1() {
//                        self.images.append(image4)
//                    }
//                } catch {
//                    
//                }
            }
        }
    }
}

#Preview {
    AsyncLetBootCamp()
}
