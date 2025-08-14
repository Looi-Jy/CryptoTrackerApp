//
//  CryptoTrackerAppTests.swift
//  CryptoTrackerAppTests
//
//  Created by JyLooi on 11/08/2025.
//

import CoreData
import SwiftUI
import Testing
@testable import CryptoTrackerApp

struct CryptoTrackerAppTests {

    @MainActor
    @Test func testViewModel() async throws {
        //Test view model function getCryptoList
        Resolver.register(MockFetchCryptoListUseCase() as FetchCryptoListProtocol)
        let vm = CryptoListViewModel(useCase: MockFetchCryptoListUseCase())
        
        let list = try await vm.getCryptoList()
        #expect(list.first?.name == "Bitcoin")
    }

    @Test func testFavouriteStoreRemove() throws {
        let controller = DataController.shared
        controller.makeTestContainer()
        
        let id = "test"
        controller.addFavourite(id: id, name: "TestFav", symbol: "tf")
        controller.saveContext()
        var favList: [FavCrypto] = controller.fetchFavourite()
        var list = favList.compactMap { $0.id }

        print("list add: \(list)")
        #expect(list.contains(id))
        
        controller.removeFavouriteForTest(id: id)
        favList = controller.fetchFavourite()
        list = favList.compactMap { $0.id }
        print("list remove: \(list)")
        #expect(list.filter { $0 == id }.first == nil)
    }
    
}
