//
//  CryptoDetailView.swift
//  CryptoTrackerApp
//
//  Created by JyLooi on 12/08/2025.
//
import SwiftUI

struct CryptoDetailView: View {
    @EnvironmentObject private var newtworkMonitor: NetworkMonitor
    var item: CryptoData
    var vm: CryptoListViewModel
    var cryptoDetailsViewModel: CryptoDetailsViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                let item = cryptoDetailsViewModel.cryptoData ?? item
                HStack(alignment: .center) {
                    Spacer()
                    AsyncCachedImage(url: URL(string: item.image ?? "")) { image in
                        image
                            .resizable()
                            .scaledToFit()
                    } placeholder: {
                        ProgressView()
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
                    HStack {
                        Image(systemName: newtworkMonitor.isConnected ? "wifi" : "wifi.slash")
                            .font(.headline)
                            .foregroundStyle(newtworkMonitor.isConnected ? .green : .red)
                        
                        FavouriteButton(item: item, vm: vm)
                    }
                }
            }
        }
        .refreshable {
            cryptoDetailsViewModel.apply()
        }
        .onAppear {
            cryptoDetailsViewModel.apply()
        }
    }
}

#Preview {
    NavigationView {
        CryptoDetailView(
            item: CryptoData.sampleCryptoData,
            vm: CryptoListViewModel(),
            cryptoDetailsViewModel: CryptoDetailsViewModel(id: "bitcoin")
        ).environmentObject(NetworkMonitor())
    }
}
