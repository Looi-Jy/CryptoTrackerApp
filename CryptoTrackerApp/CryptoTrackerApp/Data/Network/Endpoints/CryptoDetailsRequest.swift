//
//  CryptoDetailsRequest.swift
//  CryptoTrackerApp
//
//  Created by JyLooi on 11/09/2025.
//
import Foundation

final class CryptoDetailsRequest: NetworkRequestType {
    typealias Response = CryptoData
    
    var path: String = "/api/v3/coins/{id}"

    var params: [String: Any] = [:]
    
    var method: NetworkMethod = .get
}
