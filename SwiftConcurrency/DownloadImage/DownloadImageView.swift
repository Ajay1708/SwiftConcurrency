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
class ImageDownloader {
    let url = URL(string: "https://picsum.photos/200")!
    func downloadWithEscaping(completion: @escaping (_ image: UIImage?, _ err: Error?) -> Void) {
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { [weak self]
            data, resp, err in
            guard let self = self else {return}
            let image = handleResponse(data: data, resp: resp)
            completion(image, err)
        }
        .resume()
    }
    func downloadWithCombine() -> AnyPublisher<UIImage?, Error> {
        URLSession.shared.dataTaskPublisher(for: url)
            .map(handleResponse)
            .mapError({$0})
            .eraseToAnyPublisher()
    }
    func downloadWithAsync() async throws -> UIImage? {
        let (data,resp) = try await URLSession.shared.data(from: url)
        return handleResponse(data: data, resp: resp)
    }
    func handleResponse(data: Data?, resp: URLResponse?) -> UIImage? {
        guard
            let data = data,
            let image = UIImage(data: data),
            let resp = resp as? HTTPURLResponse,
            resp.statusCode >= 200 && resp.statusCode <= 300 else {
            return nil
        }
        return image
    }
}
class DownloadImageViewModel: ObservableObject {
    @Published var image: Image? = nil
    @Published var cancellables: Set<AnyCancellable> = []
    var downloader: ImageDownloader
    init() {
        self.downloader = ImageDownloader()
    }
    
    func fetchCompletionImage() {
        downloader.downloadWithEscaping { [weak self] image, err in
            guard let self = self else {return}
            if let image = image {
                DispatchQueue.main.async {
                    self.image = Image(uiImage: image)
                }
            }
        }
    }
    func fetchCombineImage() {
        downloader.downloadWithCombine()
            .receive(on: DispatchQueue.main)
            .sink { _ in
            } receiveValue: { [weak self] image in
                guard let self = self else {return}
                if let image = image {
                    self.image = Image(uiImage: image)
                }
            }
            .store(in: &cancellables)
    }
    func fetchAsyncImage() async {
        if let image = try? await downloader.downloadWithAsync() {
            await MainActor.run {
                self.image = Image(uiImage: image)
            }
        }
    }
}
#Preview {
    DownloadImageView()
}
