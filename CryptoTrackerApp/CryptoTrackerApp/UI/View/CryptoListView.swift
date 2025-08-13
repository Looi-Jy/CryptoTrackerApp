//
//  CryptoListView.swift
//  CryptoTrackerApp
//
//  Created by JyLooi on 11/08/2025.
//
import SwiftUI

struct CryptoListView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var favCryptos: FetchedResults<FavCrypto>
    @State private var isFav: Bool = false
    var item: CryptoData
    
    init(isFavourite: Bool, item: CryptoData) {
        _isFav = State(initialValue: isFavourite)
        self.item = item
    }
    
    var body: some View {
        HStack(spacing: 8) {
            AsyncCachedImage(url: URL(string: item.image ?? "")) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 40, height: 40)
            
            VStack(alignment: .leading, spacing: 3) {
                Text(item.name ?? "")
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(width: 80, alignment: .leading)
                Text(item.symbol ?? "")
            }
            
            Spacer()
            
            Text(item.currentPrice ?? 0, format: .currency(code: "USD"))
                .lineLimit(1)
            
            let priceChange = item.priceChangePercentage24H ?? 0
            Text(String(format: "%.2f", priceChange) + "%")
                .modifier(priceChangeText(priceChange: priceChange))
            
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
                    .foregroundColor(isFav ? .red : .gray)
            }
            .buttonStyle(.borderless)
        }
    }
}
