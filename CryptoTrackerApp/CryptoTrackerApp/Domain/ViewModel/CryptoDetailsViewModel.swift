//
//  CryptoDetailsViewModel.swift
//  CryptoTrackerApp
//
//  Created by JyLooi on 11/09/2025.
//

import Foundation
import Combine
import OSLog

final class CryptoDetailsViewModel: ObservableObject {
    private var coinId: String
    @Injected var cryptoDetailsUseCase: FetchCryptoDetailsProtocol
    private lazy var request: CryptoDetailsRequest = {
        return CryptoDetailsRequest()
    }()
    @Published var isLoading: Bool = false
    
    init(id: String) {
        self.coinId = id
    }
    
    // MARK: Input
    func apply() {
        request.path = request.path.replacingOccurrences(of: "{id}", with: self.coinId)
        request.params = [
            "localization": false,
            "market_data": true
        ]
        Task {
            self.cryptoData = try await getCryptoData()
        }
    }
    
    // MARK: Output
    @Published private(set) var cryptoData: CryptoData?
    
    func getCryptoData() async throws -> CryptoData? {
        isLoading = true
        do {
            isLoading = false
            return try await self.cryptoDetailsUseCase.execute(request: request)
        } catch {
            isLoading = false
            Logger.cryptoTrack.debug("Failed to get Crypto Data: \(error.localizedDescription, privacy: .private)")
            return nil
        }
    }
}
