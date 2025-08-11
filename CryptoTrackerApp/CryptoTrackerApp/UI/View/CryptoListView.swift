//
//  CryptoListView.swift
//  CryptoTrackerApp
//
//  Created by JyLooi on 11/08/2025.
//
import SwiftUI

struct CryptoListView: View {
    var item: CryptoData
    
    var body: some View {
        HStack(spacing: 8) {
            AsyncImage(url: URL(string: item.image ?? "")) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                Color.gray
            }
            .frame(width: 40, height: 40)
            
            VStack(alignment: .leading, spacing: 3) {
                Text(item.name ?? "")
                Text(item.symbol ?? "")
            }
            
            Spacer()
            
            Text(String(format: "%.5f", item.currentPrice ?? 0))
            Text(String(format: "%.5f", item.priceChangePercentage24H ?? 0) + "%")
        }
    }
}
