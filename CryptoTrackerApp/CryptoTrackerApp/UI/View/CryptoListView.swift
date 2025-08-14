//
//  CryptoListView.swift
//  CryptoTrackerApp
//
//  Created by JyLooi on 11/08/2025.
//
import SwiftUI

struct CryptoListView: View {
    var isFav: Bool = false
    var item: CryptoData
    
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
            
            FavouriteButton(isFavourite: isFav, item: item)
                .buttonStyle(.borderless)
        }
    }
}
