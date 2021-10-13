//
//  DataController.swift
//  Tally
//
//  Created by Jamie Dumont on 13/10/2021.
//

import CoreData
import SwiftUI

class DataController: ObservableObject {
    let container: NSPersistentCloudKitContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "Main")
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                fatalError("Fatal error loading persistence store: \(error.localizedDescription)")
            }
        }
    }
    
    func save() {
        if container.viewContext.hasChanges {
            try? container.viewContext.save()
        }
    }
    
    func delete(_ object: NSManagedObject) {
        container.viewContext.delete(object)
    }
    
    func deleteAll() {
        let fetchRequestValuations: NSFetchRequest<NSFetchRequestResult> = Valuation.fetchRequest()
        let batchDeleteRequestValuations = NSBatchDeleteRequest(fetchRequest: fetchRequestValuations)
        _ = try? container.viewContext.execute(batchDeleteRequestValuations)
        
        let fetchRequestItems: NSFetchRequest<NSFetchRequestResult> = Item.fetchRequest()
        let batchDeleteRequestItems = NSBatchDeleteRequest(fetchRequest: fetchRequestItems)
        _ = try? container.viewContext.execute(batchDeleteRequestItems)
    }
    
    func createSampleData() throws {
        let viewContext = container.viewContext
        
        for i in 1...5 {
            let item = Item(context: viewContext)
            item.name = "Item \(i)"
            item.purchasePrice = 45.00
            item.dateAdded = Date()
            item.valuations = []
            
            for j in 1...5 {
                let valuation = Valuation(context: viewContext)
                valuation.at = Date()
                valuation.source = "Some guy told me: \(j)"
                valuation.value = 35.00
                valuation.item = item
            }
        }
        
        try viewContext.save()
    }
    
    static var preview: DataController = {
        let dataController = DataController(inMemory: true)
        let viewContext = dataController.container.viewContext
        
        do {
            try dataController.createSampleData()
        } catch {
            fatalError("Fatal error creating data for previews: \(error.localizedDescription)")
        }
        
        return dataController
    }()
}
