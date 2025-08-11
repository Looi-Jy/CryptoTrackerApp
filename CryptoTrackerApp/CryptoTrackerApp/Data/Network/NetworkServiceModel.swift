//
//  NetworkServiceModel.swift
//  CryptoTrackerApp
//
//  Created by JyLooi on 11/08/2025.
//
import Foundation

enum NetworkMethod: String {
    case get = "GET"
    case post = "POST"
    case patch = "PATCH"
    case delete = "DELETE"
}

enum NetworkEncoding {
    case url
    case json
}

protocol NetworkRequestType {
    associatedtype Response: Decodable
    
    var path: String { get }
    var params: [String: Any] { get }
    var method: NetworkMethod { get }
}

extension NetworkRequestType {
    
    func getQueryItems() -> [URLQueryItem]? {
        return self.params.map {
            URLQueryItem(name: $0.0, value: $0.1 as? String)
        }
    }
}
