//
//  FetchCryptoListUseCase.swift
//  CryptoTrackerApp
//
//  Created by JyLooi on 11/08/2025.
//
import Foundation
import CoreData
import OSLog

protocol FetchCryptoListProtocol {
    func execute(request: CryptoListRequest) async throws -> [CryptoData]
}

final class FetchCryptoListUseCase: FetchCryptoListProtocol {
    @Injected var cryptoListProtocol: CryptoListProtocol
//    @Injected var dataController: DataController
    
    func execute(request: CryptoListRequest) async throws -> [CryptoData] {
        //TODO: get data from network or cache
        do {
            let response = try await self.cryptoListProtocol.fetchCryptoList(request: request)
            //Save to core data
            DataController.shared.deleteAllRecords(entityName: "Crypto")
            guard let cryptos = response?.data else { return [] }
            for crypto in cryptos {
                DataController.shared.addNewCrypto(item: crypto)
            }
            DataController.shared.saveContext()
            
            return cryptos
        } catch {
            //Retrive from core data
            let cryptos: [Crypto] = DataController.shared.fetchCryptos()
            let cryptoList: [CryptoData] = cryptos.map { item in
                let crypto = CryptoData(
                    id: item.id,
                    symbol: item.symbol,
                    name: item.name,
                    image: item.image,
                    currentPrice: item.currentPrice,
                    marketCap: item.marketCap,
                    totalVolume: item.totalVolume,
                    high24H: item.high,
                    low24H: item.low,
                    priceChange24H: item.priceChange,
                    priceChangePercentage24H: item.priceChangePercentage
                )
                return crypto
            }
            
//            Logger.cryptoTrack.info("data: \(cryptos, privacy: .public)")
            
            return cryptoList
        }
    }
}
