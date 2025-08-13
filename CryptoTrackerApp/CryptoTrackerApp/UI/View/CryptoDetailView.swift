//
//  CryptoDetailView.swift
//  CryptoTrackerApp
//
//  Created by JyLooi on 12/08/2025.
//
import SwiftUI

struct CryptoDetailView: View {
    @Environment(NetworkMonitor.self) private var newtworkMonitor
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var favCryptos: FetchedResults<FavCrypto>
    @State private var isFav: Bool = false
    var item: CryptoData
    
    init(isFavourite: Bool, item: CryptoData) {
        _isFav = State(initialValue: isFavourite)
        self.item = item
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
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
                        .font(.title2)
                        .foregroundStyle(newtworkMonitor.isConnected ? .green : .red)
                    
                    Button(action: {
                        isFav.toggle()
                        if isFav {
                            //add to favouriste list
                            if let id = item.id {
                                let fav = FavCrypto(context: moc)
                                fav.id = id
                                fav.name = item.name
                                fav.symbol = item.symbol
                                fav.dateAdded = Date()
                                
                                try? moc.save()
                            }
                        } else {
                            //remove from favourite list
                            if let fav = favCryptos.filter({ $0.id == item.id }).first {
                                moc.delete(fav)
                                
                                try? moc.save()
                            }
                        }
                    }) {
                        Image(systemName: isFav ? "heart.fill" : "heart")
                            .font(.title2)
                            .foregroundColor(isFav ? .red : .primary)
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        CryptoDetailView(
            isFavourite: false,
            item: CryptoData.sampleCryptoData
        ).environment(NetworkMonitor())
    }
}
