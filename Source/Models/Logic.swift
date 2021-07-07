//
//  Logic.swift
//  Signary
//
//  Created by Ameya Bhagat on 17/06/21.
//

import UIKit
import CoreData

class Logic: DataManager {
    //MARK:- PROPERTIES
    var data = [Note]()
    var trashData = [Note]()
    var combinedData = sections()
    var selectedRows: [IndexPath]?
    var id: String?
    let dateFormatter = DateFormatter()
    
    //MARK:- INIT
    override init() {
        super.init()
        loadList(loadto: &data)
        loadList(loadto: &trashData, wantTrash: true)
        dateFormatter.dateStyle = .short
    }
    //MARK:- DATA MANAGEMENT METHODS
    func dataFilter() {
        //LOAD THE DATA FROM COREDATA TO THE NOTEARRAY AND SORT IT BY DATE MODIFIED PARAMETER
        dataSort(query: K.SortBy.dateModified, asceding: false)
        combinedData[.unpinned] = data.filter({$0.isPinned == false})
        combinedData[.pinned] = data.filter({$0.isPinned == true})
    }
    
    func dataSort(query: String, asceding: Bool) {
        sort(query: query, ascending: asceding, array: &data)
        combinedData[.unpinned] = data.filter({$0.isPinned == false})
        combinedData[.pinned] = data.filter({$0.isPinned == true})
    }
    
    func attachToDataArray(_ note: Note) {
        data.append(note)
        save()
    }
    
    func sortSearch(query: String, ascending: Bool, request: NSFetchRequest<Note>) {
        sort(query: query, ascending: ascending, request: request, array: &data)
    }
}

//MARK:- DATA MARKING METHODS
extension Logic {
    
    //MARK: TRASH METHODS
    func moveOneToTrash(indexPath: IndexPath, tableView: UITableView) {
        
        if let thisTableSection = TableSection(rawValue: indexPath.section), let data = combinedData[thisTableSection] {
            switch thisTableSection {
            case .pinned:
                //SET THE PIN STATUS OF THE OBJECT
                data[indexPath.row].isTrashed = true
                data[indexPath.row].dateModified = Date()
                //START THE TABLEVIEW UPDATE BLOCK
                tableView.beginUpdates()
                //UPDATE THE PERSISTANT STORE
                save()
                //LOAD HE UPDATED PERSISTANT STORE IN THE DATA ARRAY
                dataFilter()
                //DELELTE THE ROW AT THE CURRENT INDEXPATH
                tableView.deleteRows(at: [IndexPath(row: indexPath.row, section: thisTableSection.rawValue)], with: .automatic)
                //END THE TABLEVIEW UPDATE BLOCK
                tableView.endUpdates()
                
            case .unpinned:
                print("unpinned")
                //SET THE PIN STATUS OF THE OBJECT
                data[indexPath.row].isTrashed = true
                data[indexPath.row].dateModified = Date()
                //START THE TABLEVIEW UPDATE BLOCK
                tableView.beginUpdates()
                //UPDATE THE PERSISTANT STORE
                save()
                //LOAD THE UPDATED PERSISTANT STORE IN THE DATA ARRAY
                dataFilter()
                //DELELTE THE ROW AT THE CURRENT INDEXPATH
                tableView.deleteRows(at: [IndexPath(row: indexPath.row, section: thisTableSection.rawValue)], with: .automatic)
                //END THE TABLEVIEW UPDATE BLOCK
                tableView.endUpdates()
            case .total:
                print("default")
            }
        }
    }
    
    func moveManyToTrash(tableView: UITableView) {
        //1. GET THE INDEXPATH FOR SELECTED ROWS
        if let safeRows = selectedRows {
            //2. INTIATE A VARIABLE AS NOTE OBJECT
            var note = Note()
            //3. CREATE A 'FOR IN' LOOP TO PROCESS EACH ROW SELECTED IN THE TABLEVIEW
            for indexPath in safeRows {
                //4. GET THE SECTION OF THE OBJECT AT THE INDEXPATH
                //5. RETRIEVE THE RELATED SECTION FROM THE 'combinedData' ARRAY
                if let thisTableSection = TableSection(rawValue: indexPath.section), let data = combinedData[thisTableSection] {
                    switch thisTableSection {
                    //6. IF THE SECTION IS PINNED
                    case .pinned:
                        //SET THE OBJECT AT THE CURRENT ROW TO 'NOTE' VARIABLE
                        note = data[indexPath.row]
                        //CHANGE THE 'isTrash' and 'isSelected' PROPERTIES
                        note.isTrashed = true
                        
                    case .unpinned:
                        //SET THE OBJECT AT THE CURRENT ROW TO 'NOTE' VARIABLE
                        note = data[indexPath.row]
                        //CHANGE THE 'isTrash' and 'isSelected' PROPERTIES
                        note.isTrashed = true
                        
                    default:
                        print("default")
                    }
                }
            }
            //7. BEGIN TABLEVIEW UPDATES
            tableView.beginUpdates()
            //8. DELETE THE SELECTED ROWS FROM THE TABLEVIEW
            tableView.deleteRows(at: safeRows, with: .automatic)
            //9. SAVE THE UPDATED CONTEXT TO THE PERSISTANT STORE
            save()
            //10. LOAD THE UPDATED PERSISTANT STORE
            dataFilter()
            //11. END TABLEVIEW UPDATES
            tableView.endUpdates()
        }
        selectedRows = nil
    }
    
    //MARK: RESTORE METHOD
     func restore(multipleItems: Bool, indexPath: IndexPath? = nil,tableView: UITableView) {
        
        switch multipleItems {
        case true :
            if let safeSelectedRows = selectedRows {
                var note = Note()
                
                for indexPath in safeSelectedRows {
                    note = trashData[indexPath.row]
                    note.isTrashed = false
                }
                
                tableView.beginUpdates()
                tableView.deleteRows(at: safeSelectedRows, with: .automatic)
                save()
                loadList(loadto: &trashData, wantTrash: true)
                tableView.endUpdates()
            }
            selectedRows = nil
            
        case false:
            if let safeIndexPath = indexPath {
                //1. Note at current indexPath is set to not be in trash
                trashData[safeIndexPath.row].isTrashed = false
                //2. Remove the note from current noteArray
                trashData.remove(at: safeIndexPath.row)
                //3. Delete the row from the tableView
                tableView.deleteRows(at: [safeIndexPath], with: .automatic)
                //4. Save the context
                save()
            }
        }
    }
    
    //MARK: PIN METHOD
    func setPin(indexPath: IndexPath, tableView: UITableView,state isCollapsed: Bool) {
        
        if let thisTableSection = TableSection(rawValue: indexPath.section), let data = combinedData[thisTableSection] {
            switch thisTableSection {
            
            case .unpinned:
                //1. SET THE PIN PROPERTY OF THE OBJECT AT INDEXPATH TO TRUE
                data[indexPath.row].isPinned = true
                id = data[indexPath.row].uuid!
                //2. START THE TABLEVIEW UPDATE BLOCK
                tableView.beginUpdates()
                //UPDATE THE PERSISTANT STORE WITH THE UPDATED OBJECT
                save()
                //4.LOAD THE UPDATED PERSISTANT STORE IN THE DATA ARRAY AND FILTER
                dataFilter()
                //5.FIND THE UPDATED OBJECT IN THE PINNED ARRAY
                if let objectIndex = combinedData[.pinned]?.firstIndex(where: {$0.uuid == id}) {
                    //6. INSERT NEW ROW IN THE UNPINNED SECTION OF THE TABLEVIEW
                    if isCollapsed == false {
                        tableView.insertRows(at: [IndexPath(row: objectIndex,
                                                                 section: TableSection.pinned.rawValue)],
                                             with: .fade)
                    }
                }
                //7. DELETE THE ROW IN THE UNPINNED SECTION OF THE TABLEVIEW AT THE CURRENT INDEXPATH
                tableView.deleteRows(at: [IndexPath(row: indexPath.row,
                                                    section: TableSection.unpinned.rawValue)], with: .fade)
                //8.MOVE THE ROW BELOW REMOVED ROW AT THE REMOVED ROW'S PLACE
                if indexPath.row > 0 &&
                    indexPath.row != tableView.numberOfRows(inSection: thisTableSection.rawValue) - 1
                {
                    tableView.moveRow(at: IndexPath(row: indexPath.row + 1, section: thisTableSection.rawValue),
                                           to: IndexPath(row: indexPath.row, section: thisTableSection.rawValue))
                }
                //9. SET THE TABLEVIEW EDITING TO FALSE
                tableView.isEditing = false
                //10. END THE UPDATE BLOCK FOR THE TABLEVIEW
                tableView.endUpdates()
                
            case .pinned:
                //1. SET THE PIN PROPERTY OF THE OBJECT AT INDEXPATH TO FALSE
                data[indexPath.row].isPinned = false
                id = data[indexPath.row].uuid!
                //2. START THE TABLEVIEW UPDATE BLOCK
                tableView.beginUpdates()
                //3.UPDATE THE PERSISTANT STORE WITH THE UPDATED OBJECT
                save()
                //4.LOAD THE UPDATED PERSISTANT STORE IN THE DATA ARRAY AND FILTER
                dataFilter()
                //FIND THE UPDATED OBJECT IN THE UNPINNED ARRAY
                if let objectIndex = combinedData[.unpinned]?.firstIndex(where: {$0.uuid == id}) {
                    //5. INSERT NEW ROW IN THE UNPINNED SECTION OF THE TABLEVIEW
                    tableView.insertRows(at: [IndexPath(row: objectIndex,
                                                             section: TableSection.unpinned.rawValue)],
                                              with: .automatic)
                }
                //7. DELETE THE ROW IN THE PINNED SECTION OF THE TABLEVIEW AT THE CURRENT INDEXPATH
                tableView.deleteRows(at: [IndexPath(row: indexPath.row,
                                                         section: TableSection.pinned.rawValue)],
                                          with: .automatic)
                //8. MOVE THE ROW BELOW REMOVED ROW AT THE REMOVED ROW'S PLACE
                if indexPath.row > 0 &&
                    indexPath.row != tableView.numberOfRows(inSection: thisTableSection.rawValue) - 1
                {
                    tableView.moveRow(at: IndexPath(row: indexPath.row + 1, section: thisTableSection.rawValue),
                                           to: IndexPath(row: indexPath.row, section: thisTableSection.rawValue))
                }
                //9. SET THE TABLEVIEW EDITING TO FALSE
                tableView.isEditing = false
                //10. END THE UPDATE BLOCK FOR THE TABLEVIEW
                tableView.endUpdates()
                
            default:
                print("default case")
            }
        }
    }
}

//MARK:- DATA MANIPULATION METHODS
extension Logic {
    
    func erase(selected:Bool, tableView: UITableView) {
        
        switch selected {
        
        case true:
            var note = Note()
            //GET INDEXPATH FOR NOTES SELECTED FOR DELETION
            if let safeRows = selectedRows {
                for indexPath in safeRows {
                    note = trashData[indexPath.row]
                    managedContext?.delete(note)
                }
                tableView.beginUpdates()
                //DELETE SELECTED ROWS FROM THE TABLEVIEW
                tableView.deleteRows(at: safeRows, with: .automatic)
                // save the context
                save()
                //load all the objects from the model to the noteArray
                loadList( loadto: &trashData, wantTrash: true)
                //Reload the tableView to update the UI
                tableView.endUpdates()
            }
        case false:
            
            for note in trashData {
                //Delete all the notes in the current noteArray created in Trash
                managedContext?.delete(note)
            }
            //Save the context
            save()
        }
    }
}

//MARK:- DATA RETRIEVAL METHODS
extension Logic {
    
    func fetchNote(withId id: String) -> Note {
        let request:NSFetchRequest<Note> = Note.fetchRequest()
        let predicate = NSPredicate(format: "%K == %@", #keyPath(Note.uuid), id as CVarArg)
        request.predicate = predicate
        var notes: [Note]?
        do {
            notes = try managedContext?.fetch(request)
        } catch {
            print("Error fetching data from coreData \(error).")
        }
        guard let safeNote = notes?.last else {fatalError()}
        return safeNote
    }
    
    func selectedNote(tableView: UITableView) -> String {
        
        if let selectedIndex = tableView.indexPathForSelectedRow, let thisTableSection = TableSection(rawValue: selectedIndex.section), let data = combinedData[thisTableSection] {
            switch thisTableSection {
            case .unpinned:
                id = data[selectedIndex.row].uuid!
            case .pinned:
                id = data[selectedIndex.row].uuid!
            default:
                print("default case")
            }
        }
        guard let safeID = id else {fatalError()}
        return safeID
    }
}
