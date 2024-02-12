//
//  DoTryCatchThrowsManager.swift
//  SwiftConcurrency
//
//  Created by Venkata Ajay Sai Nellori on 11/02/24.
//

import Foundation
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
