//
//  FetchCryptoListUseCase.swift
//  CryptoTrackerApp
//
//  Created by JyLooi on 11/08/2025.
//
import Foundation

protocol FetchCryptoListProtocol {
    func execute(request: CryptoListRequest) async throws -> CryptoList?
}

final class FetchCryptoListUseCase: FetchCryptoListProtocol {
    @Injected var cryptoListProtocol: CryptoListProtocol
    
    func execute(request: CryptoListRequest) async throws -> CryptoList? {
        //TODO: get data from network or cache
        return try await self.cryptoListProtocol.fetchCryptoList(request: request)
    }
}
