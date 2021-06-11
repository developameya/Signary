//
//  DataManager.swift
//  Signary
//
//  Created by Ameya Bhagat on 11/06/21.
//

import Foundation
import CoreData

/// This class will handle the common CoreData tasks for CRUD operations of persistant data store
class DataManager {
    //MARK:- PROPERTIES
    
    private lazy var stack = CoreDataStack(modelName: "Signary")
    var context: NSManagedObjectContext?
    
    //MARK:- INIT
    init() {
        context = stack.managedContext
    }
   
    /// The save function will be called to save the data stored in cotext to the coreData persistant data store.
    func save() {
        do {
            try self.context?.save()
        } catch{
            print("Error saving data to context. Error: \(error)")
        }
    }
    
    /// Loadlist will load the data from persistant store when called. This method can also be used to fetch data with specific request object of type NSRequest.
    /// - Parameters:
    ///   - request: Pass in the NSRequest object here with your query so that loadList can return the requested data
    ///   - noteArray: Specify the array property to which the requested data must be loaded to.
    func loadList (with request: NSFetchRequest<NoteMetaData> = NoteMetaData.fetchRequest(),loadto array: inout [NoteMetaData]?) {
        // use 'inout' for parameters which need to be mutable within the function
        do {
            array = try context?.fetch(request)
        }catch{
            print("Error fetching the request. Error \(error)")
        }
    }
    
    /// Use the sort function to fetch the data and sort it as required
    /// - Parameters:
    ///   - query: Pass in the String parameter which describes the property of the object in the persistant store by which the data must be sorted by (for example: date created, date Modified). Make sure such property is already available in the persistant store
    ///   - ascending: Write 'true' if the data must be sorted by ascending order
    ///   - request: Pass in request object of type NSRequest, if a specfic data is to be reuqired from the presistant store, for example, request sent from a search field.
    ///   - array: Specify the array property to which the requested data must be loaded to.
    func sort (query: String, ascending check: Bool, request: NSFetchRequest<NoteMetaData> = NoteMetaData.fetchRequest(), array: inout [NoteMetaData]?) {
        
        request.sortDescriptors = [NSSortDescriptor(key: query, ascending: check)]
        
        loadList(with: request, loadto: &array)
   
    }
}
