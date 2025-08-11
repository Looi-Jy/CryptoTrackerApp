//
//  CryptoListViewModel.swift
//  CryptoTrackerApp
//
//  Created by JyLooi on 11/08/2025.
//
import Foundation
import Combine

@MainActor
final class CryptoListViewModel: ObservableObject {
    @Injected var getCryptoListUsecase: FetchCryptoListUseCase
    private var request: CryptoListRequest = {
        return CryptoListRequest()
    }()
    
    private lazy var networkService: NetworkService = {
        return NetworkService()
    }()
    
    @Published var isLoading: Bool = false
    
    // MARK: Input
    func apply() {
        self.request.params = [
            "vs_currency": "usd",
            "order": "market_cap_desc",
            "per_page": "50",
            "page": "1"
        ]
        self.getCryptoList()
    }
    
    // MARK: Output
    @Published private(set) var cryptoList: [CryptoData] = []
    
    private func getCryptoList() {
        isLoading = true
        Task {
            do {
                let cryptoList = try await self.getCryptoListUsecase.execute(request: self.request)
                isLoading = false
                guard let cryptoList else { return }
                self.cryptoList = cryptoList.data ?? []
            } catch {
                isLoading = false
            }
        }
    }
}
