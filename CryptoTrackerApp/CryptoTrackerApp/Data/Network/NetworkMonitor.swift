//
//  NetworkDetector.swift
//  CryptoTrackerApp
//
//  Created by JyLooi on 12/08/2025.
//
import SwiftUI
import Network

@Observable
final class NetworkMonitor {
    private let networkMonitor = NWPathMonitor()
    private let workerQueue = DispatchQueue(label: "NetworkMonitor")
    var isConnected = false
    
    init() {
        networkMonitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status == .satisfied
        }
        networkMonitor.start(queue: workerQueue)
    }
}
