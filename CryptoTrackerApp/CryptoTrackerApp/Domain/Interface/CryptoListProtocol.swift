//
//  CryptoListProtocol.swift
//  CryptoTrackerApp
//
//  Created by JyLooi on 11/08/2025.
//
import Foundation

protocol CryptoListProtocol {
    func fetchCryptoList(request: CryptoListRequest) async throws -> CryptoList?
}
