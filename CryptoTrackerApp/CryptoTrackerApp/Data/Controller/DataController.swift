//
//  DataController.swift
//  CryptoTrackerApp
//
//  Created by JyLooi on 13/08/2025.
//
import CoreData
import Foundation

final class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "CryptoTrack")
    
    init() {
        container.loadPersistentStores { description, error in
            if let error {
                print("Core data failed to load: \(error.localizedDescription)")
            }
        }
    }
}
