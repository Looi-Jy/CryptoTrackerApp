//
//  ContentView.swift
//  CryptoTrackerApp
//
//  Created by JyLooi on 11/08/2025.
//

import SwiftUI
import OSLog

struct ContentView: View {
    @EnvironmentObject private var newtworkMonitor: NetworkMonitor
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
            return viewModel.favCryptoList
        }
        return viewModel.favCryptoList.filter {
            $0.name?.localizedCaseInsensitiveContains(searchText) ?? false
        }
    }
    
    var body: some View {
        if #available(iOS 17.0, *) {
            VStack {
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    if viewModel.cryptoList.isEmpty {
                        ContentUnavailableView("Content unavailable", systemImage: "exclamationmark.triangle.fill")
                    } else {
                        NavigationStack {
                            List {
                                if favCryptos.count > 0 {
                                    Section(header: Text("Favourite")) {
                                        ForEach(filterFavListData) { item in
                                            NavigationLink(value: item) {
                                                CryptoListView(item: item, vm: viewModel)
                                            }
                                        }
                                    }
                                }
                                Section(header: Text("Top 50")) {
                                    ForEach(filterListData) { item in
                                        NavigationLink(value: item) {
                                            CryptoListView(item: item, vm: viewModel)
                                        }
                                    }
                                }
                            }
                            .navigationDestination(for: CryptoData.self) { item in
                                CryptoDetailView(item: item, vm: viewModel, cryptoDetailsViewModel: CryptoDetailsViewModel(id: item.id ?? ""))
                            }
                            .navigationTitle("Crypto Tracker")
                            .toolbar {
                                ToolbarItem {
                                    Image(systemName: newtworkMonitor.isConnected ? "wifi" : "wifi.slash")
                                        .font(.headline)
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
            .onChange(of: newtworkMonitor.isConnected, initial: true) {
                if newtworkMonitor.isConnected {
                    Logger.cryptoTrack.info("Retry network request")
                    viewModel.apply()
                }
            }
        } else {
            VStack {
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    if viewModel.cryptoList.isEmpty {
                        VStack(spacing: 15) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.largeTitle)
                                .foregroundColor(.primary)
                            Text("Content unavailable")
                                .font(.title)
                        }
                    } else {
                        CryptoListTableViewWrapper(vm: viewModel)
                    }
                }
            }
            .onAppear {
                viewModel.apply()
            }
        }
    }
}

#Preview {
    NavigationView {
        ContentView(viewModel: CryptoListViewModel())
            .environmentObject(NetworkMonitor())
    }
}
