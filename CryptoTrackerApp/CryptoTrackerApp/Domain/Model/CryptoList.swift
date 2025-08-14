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
//    let marketCapRank: Int?
//    let fullyDilutedValuation: Double?
    let totalVolume: Double?
    let high24H: Double?
    let low24H: Double?
    let priceChange24H: Double?
    let priceChangePercentage24H: Double?
//    let marketCapChange24H: Double?
//    let marketCapChangePercentage24H: Double?
//    let circulatingSupply: Double?
//    let totalSupply: Double?
//    let maxSupply: Double?
//    let ath: Double?
//    let athChangePercentage: Double?
//    let athDate: String?
//    let atl: Double?
//    let atlChangePercentage: Double?
//    let atlDate: String?
//    let lastUpdated: String?
}

extension CryptoData {
    static let sampleCryptoData: CryptoData = CryptoData(
        id: "bitcoin",
        symbol: "btc",
        name: "Bitcoin",
        image: "https://coin-images.coingecko.com/coins/images/1/large/bitcoin.png?1696501400",
        currentPrice: 119553,
        marketCap: 2381348295947,
//        marketCapRank: 1,
//        fullyDilutedValuation: 2381348295947,
        totalVolume: 54469687225,
        high24H: 122227,
        low24H: 118199,
        priceChange24H: 997.88,
        priceChangePercentage24H: 0.8417
//        marketCapChange24H: 21219714861,
//        marketCapChangePercentage24H: 0.89909,
//        circulatingSupply: 19904843.0,
//        totalSupply: 19904843.0,
//        maxSupply: 21000000.0,
//        ath: 122838,
//        athChangePercentage: -2.37301,
//        athDate: "2025-07-14T07:56:01.937Z",
//        atl: 67.81,
//        atlChangePercentage: 176754.15021,
//        atlDate: "2013-07-06T00:00:00.000Z",
//        lastUpdated: "2025-08-11T12:59:42.122Z"
    )
}
