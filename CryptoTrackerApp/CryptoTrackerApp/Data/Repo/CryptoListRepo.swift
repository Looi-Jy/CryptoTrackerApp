//
//  CryptoListRepo.swift
//  CryptoTrackerApp
//
//  Created by JyLooi on 11/08/2025.
//
import Foundation

final class CryptoListRepo {
    @Injected var networkService: NetworkServiceType
}

extension CryptoListRepo: CryptoListProtocol {
    func fetchCryptoList(request: CryptoListRequest) async throws -> CryptoList? {
        return try await self.networkService.response(from: request)
    }
}
