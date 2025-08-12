//
//  ContentView.swift
//  CryptoTrackerApp
//
//  Created by JyLooi on 11/08/2025.
//

import SwiftUI

struct ContentView: View {
    @Environment(NetworkMonitor.self) private var newtworkMonitor
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
                            ForEach(filterListData) { item in
                                NavigationLink(value: item) {
                                    CryptoListView(item: item)
                                }
                            }
                        }
                        .navigationDestination(for: CryptoData.self) { item in
                            CryptoDetailView(item: item)
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
}

#Preview {
    NavigationStack {
        ContentView(viewModel: CryptoListViewModel())
            .environment(NetworkMonitor())
    }
}
