//
//  FetchCryptoDetailsUseCase.swift
//  CryptoTrackerApp
//
//  Created by JyLooi on 11/09/2025.
//
import Foundation
import CoreData

protocol FetchCryptoDetailsProtocol {
    func execute(request: CryptoDetailsRequest) async throws -> CryptoData?
}

final class FetchCryptoDetailsUseCase: FetchCryptoDetailsProtocol {
    @Injected var cryptoDetailsProtocol: CryptoDetailsProtocol
    
    func execute(request: CryptoDetailsRequest) async throws -> CryptoData? {
        do {
            let response = try await self.cryptoDetailsProtocol.fetchCryptoDetails(request: request)
            return response
        } catch {
            //Retrive from core data
            let id = request.path.components(separatedBy: "/").last
            let cryptos: [Crypto] = DataController.shared.fetchCryptos()
            let item = cryptos.filter { $0.id == id }.first
            let crypto: CryptoData = CryptoData(
                id: item?.id,
                symbol: item?.symbol,
                name: item?.name,
                image: item?.image,
                currentPrice: item?.currentPrice,
                marketCap: item?.marketCap,
                totalVolume: item?.totalVolume,
                high24H: item?.high,
                low24H: item?.low,
                priceChange24H: item?.priceChange,
                priceChangePercentage24H: item?.priceChangePercentage
            )
            return crypto
        }
    }
}
