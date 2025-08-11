//
//  NetworkServiceError.swift
//  CryptoTrackerApp
//
//  Created by JyLooi on 11/08/2025.
//
import Foundation

enum NetworkServiceError: Error {
    case apiError
    case encodingFailed(EncodingError)
    case decodingFailed(DecodingError)
    case invalidStatusCode(statusCode: Int)
    case requestFailed(URLError)
    case otherError(Error)
}
