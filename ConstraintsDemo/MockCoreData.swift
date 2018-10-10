//
//  MockCoreData.swift
//  ConstraintsDemo
//
//  Created by madi on 10/5/18.
//  Copyright © 2018 com.ibm. All rights reserved.
//

import Foundation
import CoreData

class MockCoreData {
    var mockedCtx: NSManagedObjectContext! = nil
    var sqlCtx: NSManagedObjectContext! = nil
    
    init() {
        mockedCtx = setupInMemoryContext()
//        sqlCtx = setupSQLMemoryContext()
        sqlCtx = setupSQLPersistentContainer()
    }
    
    func getMockedContext() -> NSManagedObjectContext {
        return mockedCtx
    }
    
    func getSQLContext() -> NSManagedObjectContext {
        return sqlCtx
    }
    
    func setupInMemoryContext() -> NSManagedObjectContext {
        do {
            let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
            let modelURL = Bundle.main.url(forResource: "ConstraintsDemo", withExtension: "momd")
            let newObjectModel = NSManagedObjectModel.init(contentsOf: modelURL!)
            let psc = NSPersistentStoreCoordinator(managedObjectModel: newObjectModel!)
            try psc.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
            
            managedObjectContext.persistentStoreCoordinator = psc
            managedObjectContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
            return managedObjectContext
        } catch {
            fatalError("Setup in memory failed \(error)")
        }
        return NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    }
    
    func setupSQLMemoryContext() -> NSManagedObjectContext {
        do {
            let modelURL = Bundle.main.url(forResource: "ConstraintsDemo", withExtension: "momd")
            let mom = NSManagedObjectModel(contentsOf: modelURL!)
            
            let psc = NSPersistentStoreCoordinator(managedObjectModel: mom!)
            
            let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
            managedObjectContext.persistentStoreCoordinator = psc
            guard let docURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else {
                fatalError("Unable to resolve document directory")
            }
            let storeURL = docURL.appendingPathComponent("ConstraintsDemo.sqlite")
            
            try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
            managedObjectContext.persistentStoreCoordinator = psc
            managedObjectContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
            return managedObjectContext
        } catch {
            fatalError("Setup sql lite memory failed \(error)")
        }
        
        return NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    }
    
    func setupSQLPersistentContainer() -> NSManagedObjectContext {
        let container = NSPersistentContainer(name: "ConstraintsDemo")
        container.loadPersistentStores { (desc, error) in
            if let error = error {
                fatalError("Failed to load core data: \(error)")
            }
        }
        
        let url = NSPersistentContainer.defaultDirectoryURL()
        let description = NSPersistentStoreDescription(url: url)
        // Default store type is NSSQLiteStoreType
        container.persistentStoreDescriptions = [description]
        container.viewContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        
        return container.viewContext
    }
}
