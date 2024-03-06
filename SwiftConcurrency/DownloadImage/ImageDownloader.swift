//
//  ImageDownloader.swift
//  SwiftConcurrency
//
//  Created by Venkata Ajay Sai Nellori on 11/02/24.
//

import Foundation
import SwiftUI
import Combine

class ImageDownloader {
    let url: URL
    init(urlString: String = "https://picsum.photos/200") {
        url = URL(string: urlString)!
    }
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
    func downloadWithAsync(from urlString: String) async throws -> UIImage? {
        guard let url = URL(string: urlString) else { return nil }
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
