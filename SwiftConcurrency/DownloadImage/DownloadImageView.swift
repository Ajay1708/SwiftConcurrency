//
//  DownloadImageView.swift
//  SwiftConcurrency
//
//  Created by Venkata Ajay Sai Nellori on 08/02/24.
//

import SwiftUI
import Combine
struct DownloadImageView: View {
    @StateObject var vm = DownloadImageViewModel()
    var body: some View {
        VStack {
            if let image = vm.image {
                image
            }
        }
        .onAppear {
            fetchImage()
        }
        .onTapGesture {
            fetchImage()
        }
    }
    func fetchImage() {
        Task {
            await vm.fetchAsyncImage()
        }
    }
}

#Preview {
    DownloadImageView()
}
