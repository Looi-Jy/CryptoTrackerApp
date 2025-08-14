//
//  CryptoListViewModel.swift
//  CryptoTrackerApp
//
//  Created by JyLooi on 11/08/2025.
//
import Foundation
import Combine
import OSLog

@MainActor
final class CryptoListViewModel: ObservableObject {
    @Injected var getCryptoListUsecase: FetchCryptoListProtocol
    private var request: CryptoListRequest = {
        return CryptoListRequest()
    }()
    
    @Published var isLoading: Bool = false
    
    init() {}
    
    public init(useCase: FetchCryptoListProtocol) {
        self.getCryptoListUsecase = useCase
    }
    
    // MARK: Input
    func apply() {
        self.request.params = [
            "vs_currency": "usd",
            "order": "market_cap_desc",
            "per_page": "50",
            "page": "1"
        ]
        
        Task {
            self.cryptoList = try await self.getCryptoList()
        }
    }
    
    // MARK: Output
    @Published private(set) var cryptoList: [CryptoData] = []
    
    public func getCryptoList() async throws -> [CryptoData] {
        isLoading = true
        do {
            isLoading = false
            return try await self.getCryptoListUsecase.execute(request: self.request)
        } catch {
            isLoading = false
            Logger.cryptoTrack.debug("Failed to get Crypto List: \(error.localizedDescription, privacy: .private)")
            return []
        }
    }
}
