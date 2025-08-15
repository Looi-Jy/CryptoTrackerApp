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
    var item: CryptoData
    var vm: CryptoListViewModel
    
    var body: some View {
        var isFav = favCryptos.filter({ $0.id == item.id }).first != nil
        Button(action: {
            isFav.toggle()
            guard let id = item.id else { return }
            vm.addRemoveFav(isFav: isFav, id: id, name: item.name ?? "", symbol: item.symbol ?? "")
        }) {
            Image(systemName: isFav ? "heart.fill" : "heart")
                .font(.headline)
                .foregroundColor(isFav ? .red : .primary)
        }
    }
}

#Preview {
    FavouriteButton(
        item: CryptoData.sampleCryptoData,
        vm: CryptoListViewModel()
    )
}
