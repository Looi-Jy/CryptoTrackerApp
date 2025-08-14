//
//  DataController.swift
//  CryptoTrackerApp
//
//  Created by JyLooi on 13/08/2025.
//
import CoreData
import Foundation
import OSLog

final class DataController: ObservableObject {
    static let shared = DataController()
    let container = NSPersistentContainer(name: "CryptoTrack")
    
    init() {
        container.loadPersistentStores { description, error in
            if let error {
                Logger.cryptoTrack.debug("Core data failed to load: \(error.localizedDescription, privacy: .private)")
            }
        }
    }
    
    func saveContext() {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let error = error as NSError
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    
    func deleteAllRecords(entityName: String) {
        let context = container.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(batchDeleteRequest)
            try context.save()
        } catch {
            Logger.cryptoTrack.debug("Error deleting records: \(error, privacy: .private)")
        }
    }
    
    func addNewCrypto(item: CryptoData) {
        let context = container.viewContext
        let newEntity = Crypto(context: context)
        newEntity.id = item.id
        newEntity.symbol = item.symbol
        newEntity.name = item.name
        newEntity.image = item.image
        newEntity.currentPrice = item.currentPrice ?? 0
        newEntity.marketCap = item.marketCap ?? 0
        newEntity.totalVolume = item.totalVolume ?? 0
        newEntity.high = item.high24H ?? 0
        newEntity.low = item.low24H ?? 0
        newEntity.priceChange = item.priceChange24H ?? 0
        newEntity.priceChangePercentage = item.priceChangePercentage24H ?? 0
    }
    
    func fetchCryptos() -> [Crypto] {
        let context = container.viewContext
        let fetchRequest: NSFetchRequest<Crypto> = Crypto.fetchRequest()
        do {
            let entities = try context.fetch(fetchRequest)
            return entities
        } catch {
            Logger.cryptoTrack.debug("Failed to fetch entities: \(error, privacy: .private)")
            return []
        }
}
}
