//
//  ContentView.swift
//  CryptoTrackerApp
//
//  Created by JyLooi on 11/08/2025.
//

import SwiftUI

struct ContentView: View {
    @Environment(NetworkMonitor.self) private var newtworkMonitor
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var favCryptos: FetchedResults<FavCrypto>
    @StateObject var viewModel = CryptoListViewModel()
    @State private var searchText: String = ""
    
    private var filterListData: [CryptoData] {
        if searchText.isEmpty {
            return viewModel.cryptoList
        }
        return viewModel.cryptoList.filter {
            $0.name?.localizedCaseInsensitiveContains(searchText) ?? false
        }
    }
    
    private var filterFavListData: [CryptoData] {
        if searchText.isEmpty {
            return favListData
        }
        return favListData.filter {
            $0.name?.localizedCaseInsensitiveContains(searchText) ?? false
        }
    }
    
    private var favListData: [CryptoData] {
        let favId = Set(favCryptos.map { $0.id })
        return viewModel.cryptoList.filter({ favId.contains($0.id) })
    }
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView()
            } else {
                NavigationStack {
                    if viewModel.cryptoList.isEmpty {
                        ContentUnavailableView("Content unavailable", systemImage: "exclamationmark.triangle.fill")
                    } else {
                        List {
                            if favCryptos.count > 0 {
                                Section(header: Text("Favourite")) {
                                    ForEach(filterFavListData) { item in
                                        NavigationLink(value: item) {
                                            CryptoListView(isFavourite: isFav(id: item.id ?? ""), item: item)
                                        }
                                    }
                                }
                            }
                            Section(header: Text("Top 50")) {
                                ForEach(filterListData) { item in
                                    NavigationLink(value: item) {
                                        CryptoListView(isFavourite: isFav(id: item.id ?? ""), item: item)
                                    }
                                }
                            }
                        }
                        .navigationDestination(for: CryptoData.self) { item in
                            CryptoDetailView(isFavourite: isFav(id: item.id ?? ""), item: item)
                        }
                        .navigationTitle("Crypto Tracker")
                        .toolbar {
                            ToolbarItem {
                                Image(systemName: newtworkMonitor.isConnected ? "wifi" : "wifi.slash")
                                    .font(.title2)
                                    .foregroundStyle(newtworkMonitor.isConnected ? .green : .red)
                            }
                        }
                        .listStyle(.grouped)
                        .searchable(text: $searchText)
                        .refreshable {
                            viewModel.apply()
                        }
                    }
                }
            }
        }
        .onAppear {
            viewModel.apply()
        }
    }
    
    private func isFav(id: String) -> Bool {
        return favCryptos.filter({ $0.id == id }).first != nil
    }
}

#Preview {
    NavigationStack {
        ContentView(viewModel: CryptoListViewModel())
            .environment(NetworkMonitor())
    }
}
