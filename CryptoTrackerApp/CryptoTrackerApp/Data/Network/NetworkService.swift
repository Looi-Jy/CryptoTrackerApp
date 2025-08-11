//
//  NetworkService.swift
//  CryptoTrackerApp
//
//  Created by JyLooi on 11/08/2025.
//
import Foundation

protocol NetworkServiceType {
    func response<Request>(from request: Request) async throws -> Request.Response? where Request: NetworkRequestType
}

final class NetworkService: NetworkServiceType {
    var encoding: NetworkEncoding = .url
    var uploadPath: String = ""
    private var baseURL: URL?
    private var baseString: String
    
    init() {
        self.baseString = "https://api.coingecko.com"
        self.baseURL = URL(string: self.baseString)
    }
    
    func response<Request>(from request: Request) async throws (NetworkServiceError) -> Request.Response? where Request: NetworkRequestType {
        do {
            guard let pathURL = URL(string: request.path, relativeTo: self.baseURL),
                  var urlComponents =  URLComponents(url: pathURL, resolvingAgainstBaseURL: true),
                  let url: URL = urlComponents.url else {
                throw NetworkServiceError.apiError
            }
            
            var urlRequest = URLRequest(url: url)
            
            switch self.encoding {
            case .url:
                urlComponents.queryItems =  request.getQueryItems()
                if let url = urlComponents.url {
                    urlRequest.url = url
                }
            case .json:
                let json = try? JSONSerialization.data(withJSONObject: request.params)
                urlRequest.httpBody = json
            }

            urlRequest.httpMethod = request.method.rawValue
            
            let decorder = JSONDecoder()
            decorder.keyDecodingStrategy = .convertFromSnakeCase
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                throw NetworkServiceError.invalidStatusCode(statusCode: -1)
            }
                    
            guard (200...299).contains(statusCode) else {
                throw NetworkServiceError.invalidStatusCode(statusCode: statusCode)
            }
            
            return try decorder.decode(Request.Response.self, from: data)
            
        } catch let error as DecodingError {
            throw .decodingFailed(error)
        } catch let error as EncodingError {
            throw .encodingFailed(error)
        } catch let error as URLError {
            throw .requestFailed(error)
        } catch let error as NetworkServiceError {
            throw error
        } catch {
            throw .otherError(error)
        }
    }
}
