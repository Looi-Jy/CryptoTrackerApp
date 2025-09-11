//
//  CryptoListRequest.swift
//  CryptoTrackerApp
//
//  Created by JyLooi on 11/08/2025.
//
import Foundation

final class CryptoListRequest: NetworkRequestType {
    
    typealias Response = CryptoList
    
    var path: String = "/api/v3/coins/markets"

    var params: [String: Any] = [:]
    
    var method: NetworkMethod = .get
}

