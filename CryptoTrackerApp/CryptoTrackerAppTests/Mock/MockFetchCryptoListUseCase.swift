//
//  MockFetchCryptoListUseCase.swift
//  CryptoTrackerAppTests
//
//  Created by JyLooi on 14/08/2025.
//

import Foundation

final class MockFetchCryptoListUseCase: FetchCryptoListProtocol {
    func execute(request: CryptoListRequest) async throws -> [CryptoData] {
        return [CryptoData.sampleCryptoData]
    }
}
