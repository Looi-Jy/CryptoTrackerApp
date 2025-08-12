//
//  CryptoDetailView.swift
//  CryptoTrackerApp
//
//  Created by JyLooi on 12/08/2025.
//
import SwiftUI

struct CryptoDetailView: View {
    @Environment(NetworkMonitor.self) private var newtworkMonitor
    var item: CryptoData
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .center) {
                Spacer()
                AsyncImage(url: URL(string: item.image ?? "")) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    Color.gray
                }
                .frame(maxWidth: 200, maxHeight: 200)
                Spacer()
            }
            
            Text("Symbol: \(item.symbol ?? "")")
            Text("Current Price: \((item.currentPrice ?? 0).formatted(.currency(code: "USD")))")
            HStack(spacing: 5) {
                Text("Price Changed 24 hrs: \((item.priceChange24H ?? 0).formatted(.currency(code: "USD")))")
                let priceChange = item.priceChangePercentage24H ?? 0
                Text(String(format: "%.2f", priceChange) + "%")
                    .modifier(priceChangeText(priceChange: priceChange))
            }
            
            Text("Market Cap: \((item.marketCap ?? 0).formatted(.currency(code: "USD")))")
            Text("Volume: \((item.totalVolume ?? 0).formatted(.currency(code: "USD")))")
            Text("High 24 hrs: \((item.high24H ?? 0).formatted(.currency(code: "USD")))")
            Text("Low 24 hrs: \((item.low24H ?? 0).formatted(.currency(code: "USD")))")
            
        }
        .frame(
            minWidth: 0,
            maxWidth: .infinity,
            minHeight: 0,
            maxHeight: .infinity,
            alignment: .topLeading
        )
        .padding(15)
        .navigationTitle(item.name ?? "")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem {
                Image(systemName: newtworkMonitor.isConnected ? "wifi" : "wifi.slash")
                    .font(.title2)
                    .foregroundStyle(newtworkMonitor.isConnected ? .green : .red)
            }
        }
    }
}

#Preview {
    NavigationStack {
        CryptoDetailView(item: CryptoData(id: "bitcoin", symbol: "btc", name: "Bitcoin", image: "https://coin-images.coingecko.com/coins/images/1/large/bitcoin.png?1696501400", currentPrice: 119553, marketCap: 2381348295947, marketCapRank: 1, fullyDilutedValuation: 2381348295947, totalVolume: 54469687225, high24H: 122227, low24H: 118199, priceChange24H: 997.88, priceChangePercentage24H: 0.8417, marketCapChange24H: 21219714861, marketCapChangePercentage24H: 0.89909, circulatingSupply: 19904843.0, totalSupply: 19904843.0, maxSupply: 21000000.0, ath: 122838, athChangePercentage: -2.37301, athDate: "2025-07-14T07:56:01.937Z", atl: 67.81, atlChangePercentage: 176754.15021, atlDate: "2013-07-06T00:00:00.000Z", lastUpdated: "2025-08-11T12:59:42.122Z")).environment(NetworkMonitor())
    }
    
}
