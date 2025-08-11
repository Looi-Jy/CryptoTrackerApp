//
//  ContentView.swift
//  CryptoTrackerApp
//
//  Created by JyLooi on 11/08/2025.
//

import SwiftUI

struct ContentView: View {
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
                                CryptoListView(item: item)
                            }
                        }
                    }
                }
            }
        }
        .listStyle(.grouped)
        .searchable(text: $searchText)
        .refreshable {
            viewModel.apply()
        }
        .onAppear {
            viewModel.apply()
        }
    }
}

#Preview {
    ContentView()
}
