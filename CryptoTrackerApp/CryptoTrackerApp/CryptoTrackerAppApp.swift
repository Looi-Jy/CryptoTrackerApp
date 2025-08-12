//
//  CryptoTrackerAppApp.swift
//  CryptoTrackerApp
//
//  Created by JyLooi on 11/08/2025.
//

import SwiftUI

@main
struct CryptoTrackerAppApp: App {
    @State private var networkMonitor = NetworkMonitor()
    
    init() {
        Resolver.register(NetworkService() as NetworkServiceType)
        Resolver.register(CryptoListRepo() as CryptoListProtocol)
        Resolver.register(FetchCryptoListUseCase() as FetchCryptoListUseCase)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(networkMonitor)
        }
    }
}
