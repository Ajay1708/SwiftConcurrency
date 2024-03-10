//
//  ContinuationBootcamp.swift
//  SwiftConcurrency
//
//  Created by Venkata Ajay Sai Nellori on 06/03/24.
//

import SwiftUI
/// By using Continuations we can convert the code that is not compatible with async await to code that is compatible with async await
/// Use case is when you are working with SDKs and apis that are not updated for swift concurrency you can use continuation to convert them to be usable with your async await swift concurrency code
struct ContinuationBootcamp: View {
    @StateObject var viewModel = ContinuationBootcampViewModel()
    var body: some View {
        ZStack {
            if let image = viewModel.image  {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
        }
        .task {
            await viewModel.fetchImage()
        }
    }
}

#Preview {
    ContinuationBootcamp()
}
