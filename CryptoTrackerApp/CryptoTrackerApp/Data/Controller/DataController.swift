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
    var container = NSPersistentContainer(name: "CryptoTrack")
    
    init() {
        container.loadPersistentStores { description, error in
            if let error {
                Logger.cryptoTrack.debug("Core data failed to load: \(error.localizedDescription, privacy: .private)")
            }
        }
    }
    
    func makeTestContainer() {
        let modelName = "CryptoTrack"

        guard let modelURL = Bundle(for: FavCrypto.self).url(forResource: modelName, withExtension: "momd"),
              let model = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Could not load model from bundle")
        }

        container = NSPersistentContainer(name: modelName, managedObjectModel: model)

        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]

        container.loadPersistentStores { (desc, error) in
            if let error = error {
                fatalError("Failed to load store: \(error)")
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
    
    func addFavourite(id: String, name: String, symbol: String) {
        let context = container.viewContext
        let newEntity = FavCrypto(context: context)
        newEntity.id = id
        newEntity.name = name
        newEntity.symbol = symbol
        newEntity.dateAdded = Date()
    }
    
    func removeFavourite(id: String) {
        let context = container.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavCrypto")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        deleteRequest.resultType = .resultTypeObjectIDs

        do {
            let result = try context.execute(deleteRequest) as? NSBatchDeleteResult
            if let objectIDs = result?.result as? [NSManagedObjectID] {
                let changes: [AnyHashable: Any] = [NSDeletedObjectsKey: objectIDs]
                NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [context])
            }
        } catch {
            Logger.cryptoTrack.debug("Error deleting favourite: \(error, privacy: .private)")
        }
    }
    
    func removeFavouriteForTest(id: String) {
        let context = container.viewContext
        let fetchRequest: NSFetchRequest<FavCrypto> = FavCrypto.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        
        do {
            let objects = try context.fetch(fetchRequest)
            for object in objects {
                context.delete(object)
            }
            try context.save()
        } catch {
            Logger.cryptoTrack.debug("Error deleting favourite: \(error, privacy: .private)")
        }
    }

    
    func fetchFavourite() -> [FavCrypto] {
        let context = container.viewContext
        let fetchRequest: NSFetchRequest<FavCrypto> = FavCrypto.fetchRequest()
        do {
            let entities = try context.fetch(fetchRequest)
            return entities
        } catch {
            Logger.cryptoTrack.debug("Failed to fetch favourite: \(error, privacy: .private)")
            return []
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
            Logger.cryptoTrack.debug("Failed to fetch cryptos: \(error, privacy: .private)")
            return []
        }
    }
}
