//
//  DataManager.swift
//  Signary
//
//  Created by Ameya Bhagat on 17/06/21.
//

import Foundation
import CoreData

class DataManager {
    //MARK:- PROPERTIES
    
    private lazy var stack = CoreDataStack(modelName: "Signary")
    var managedContext: NSManagedObjectContext?
    
    //MARK:- INIT
    init() {
        managedContext = stack.managedContext
    }
   
    /// The save function will be called to save the data stored in cotext to the coreData persistant data store.
    func save() {
        do {
            try self.managedContext?.save()
        } catch{
            print("Error saving data to context. Error: \(error)")
        }
    }
    
    /// Loadlist will load the data from persistant store when called. This method can also be used to fetch data with specific request object of type NSRequest.
    /// - Parameters:
    ///   - request: Pass in the NSRequest object here with your query so that loadList can return the requested data
    ///   - noteArray: Specify the array property to which the requested data must be loaded to.
    ///   - wantTrash:  Specify the boolean true if trash marked notes are to be loaded in the array.
    
    func loadList (with request: NSFetchRequest<Note> = Note.fetchRequest(),loadto array: inout [Note], wantTrash: Bool? = false) {
        // use 'inout' for parameters which need to be mutable within the function
        do {
            array = try managedContext!.fetch(request)
        }catch{
            print("Error fetching the request. Error \(error)")
        }
        
        
        if wantTrash == false {
            array.removeAll(where: {$0.isTrashed == true || $0.isClear == true})
        } else if wantTrash == false {
            array.removeAll(where: {$0.isTrashed == true || $0.isClear == true})
        } else if wantTrash == true {
            array.removeAll(where: {$0.isTrashed == false || $0.isClear == true})
        }
    }
    
    /// Use the sort function to fetch the data and sort it as required
    /// - Parameters:
    ///   - query: Pass in the String parameter which describes the property of the object in the persistant store by which the data must be sorted by (for example: date created, date Modified). Make sure such property is already available in the persistant store
    ///   - check: Write 'true' if the data must be sorted by ascending order
    ///   - request: Pass in request object of type NSRequest, if a specfic data is to be reuqired from the presistant store, for example, request sent from a search field.
    ///   - array: Specify the array property to which the requested data must be loaded to.
    func sort (query: String, ascending check: Bool, request: NSFetchRequest<Note> = Note.fetchRequest(), array: inout [Note]) {
        
        request.sortDescriptors = [NSSortDescriptor(key: query, ascending: check)]
        
        loadList(with: request, loadto: &array)
    }
}
