//
//  CryptoTrackerAppApp.swift
//  CryptoTrackerApp
//
//  Created by JyLooi on 11/08/2025.
//

import SwiftUI

@main
struct CryptoTrackerAppApp: App {
    @StateObject private var networkMonitor = NetworkMonitor.shared
    @StateObject private var dataController  = DataController.shared
    
    init() {
        Resolver.register(NetworkService() as NetworkServiceType)
        Resolver.register(CryptoListRepo() as CryptoListProtocol)
        Resolver.register(FetchCryptoListUseCase() as FetchCryptoListProtocol)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(networkMonitor)
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
