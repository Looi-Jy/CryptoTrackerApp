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
        Task {
            try await asyncApply()
        }
    }
    
    func asyncApply() async throws {
        self.request.params = [
            "vs_currency": "usd",
            "order": "market_cap_desc",
            "per_page": "50",
            "page": "1"
        ]
        self.cryptoList = try await self.getCryptoList()
        self.updateFavList()
    }
    
    // MARK: Output
    @Published private(set) var cryptoList: [CryptoData] = []
    @Published var favCryptoList: [CryptoData] = []
    
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
    
    private func updateFavList() {
        let favList = DataController.shared.fetchFavourite()
        let favIds = favList.map { $0.id }
        favCryptoList = cryptoList.filter { favIds.contains($0.id) }
    }
    
    func addRemoveFav(isFav: Bool, id: String, name: String, symbol: String) {
        if isFav {
            //add to favouriste list
            DataController.shared.addFavourite(id: id, name: name , symbol: symbol)
            DataController.shared.saveContext()
        } else {
            //remove from favourite list
            DataController.shared.removeFavourite(id: id)
        }
        updateFavList()
    }
    
}
