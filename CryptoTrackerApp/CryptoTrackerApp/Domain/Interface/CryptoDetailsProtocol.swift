//
//  CryptoDetailsProtocol.swift
//  CryptoTrackerApp
//
//  Created by JyLooi on 11/09/2025.
//
import Foundation

protocol CryptoDetailsProtocol {
    func fetchCryptoDetails(request: CryptoDetailsRequest) async throws -> CryptoData?
}
