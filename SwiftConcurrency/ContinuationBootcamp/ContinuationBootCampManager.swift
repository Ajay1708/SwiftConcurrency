//
//  ContinuationBootCampManager.swift
//  SwiftConcurrency
//
//  Created by Venkata Ajay Sai Nellori on 10/03/24.
//

import Foundation
class ContinuationBootCampManager {
    func getData(from urlString: String) async throws -> Data {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        return try await withCheckedThrowingContinuation { continuation in
            URLSession.shared.dataTask(with: URLRequest(url: url)) { data, resp, err in
                // A continuation must be resumed exactly once. If the continuation has already been resumed through this object, then the attempt to resume the continuation will trap.
                if let data {
                    continuation.resume(returning: data)
                } else if let err {
                    continuation.resume(throwing: err)
                } else {
                    continuation.resume(throwing: URLError.init(URLError.Code.badURL))
                }
            }
            .resume()
        }
    }
}
