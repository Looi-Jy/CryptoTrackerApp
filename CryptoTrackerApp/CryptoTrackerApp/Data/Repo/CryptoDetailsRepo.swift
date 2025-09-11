//
//  CryptoDetailsRepo.swift
//  CryptoTrackerApp
//
//  Created by JyLooi on 11/09/2025.
//
import Foundation

final class CryptoDetailsRepo: CryptoDetailsProtocol {
    @Injected var networkService: NetworkServiceType
    
    func fetchCryptoDetails(request: CryptoDetailsRequest) async throws -> CryptoData? {
        return try await self.networkService.response(from: request)
    }
}
