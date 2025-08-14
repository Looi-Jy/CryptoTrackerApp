//
//  FavouriteButton.swift
//  CryptoTrackerApp
//
//  Created by JyLooi on 13/08/2025.
//

import SwiftUI

struct FavouriteButton: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var favCryptos: FetchedResults<FavCrypto>
    @State private var isFav: Bool = false
    var item: CryptoData
    
    init(isFavourite: Bool, item: CryptoData) {
        _isFav = State(initialValue: isFavourite)
        self.item = item
    }
    
    var body: some View {
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

#Preview {
    FavouriteButton(
        isFavourite: true,
        item: CryptoData.sampleCryptoData
    )
}
