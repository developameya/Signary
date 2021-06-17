//
//  CoreDataStack.swift
//  Signary
//
//  Created by Ameya Bhagat on 17/06/21.
//

import Foundation
import CoreData

class CoreDataStack {
    
    //MARK:- INIT
    init(modelName: String) {
        self.modelName = modelName
        ColorValueTransformer.register()
    }
    //MARK:- PROPERTIES
    private let modelName: String
    private lazy var persistanContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: modelName)
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    lazy var managedContext: NSManagedObjectContext = {
        return self.persistanContainer.viewContext
    }()
    
    //MARK:- DATA MANIPULATION METHODS
    func saveContext() {
        guard managedContext.hasChanges else {return}
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
    }
}
