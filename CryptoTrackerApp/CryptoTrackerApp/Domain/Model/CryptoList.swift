//
//  CryptoList.swift
//  CryptoTrackerApp
//
//  Created by JyLooi on 11/08/2025.
//
struct CryptoList: Codable {
    var data: [CryptoData]?
    
    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        var cryptoList: [CryptoData] = []
        while !container.isAtEnd {
            cryptoList.append(try container.decode(CryptoData.self))
        }
        data = cryptoList
    }
}

struct CryptoData: Codable, Hashable, Identifiable {
    let id: String?
    let symbol: String?
    let name: String?
    let image: String?
    let currentPrice: Double?
    let marketCap: Double?
    let marketCapRank: Int?
    let fullyDilutedValuation: Double?
    let totalVolume: Double?
    let high24H: Double?
    let low24H: Double?
    let priceChange24H: Double?
    let priceChangePercentage24H: Double?
    let marketCapChange24H: Double?
    let marketCapChangePercentage24H: Double?
    let circulatingSupply: Double?
    let totalSupply: Double?
    let maxSupply: Double?
    let ath: Double?
    let athChangePercentage: Double?
    let athDate: String?
    let atl: Double?
    let atlChangePercentage: Double?
    let atlDate: String?
    let lastUpdated: String?
}
