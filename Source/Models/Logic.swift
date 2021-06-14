//
//  Logic.swift
//  Signary
//
//  Created by Ameya Bhagat on 12/06/21.
//

import Foundation
import UIKit

///This class provides the logic to load appropriate data as called by the app.
class Logic: DataManager {
    var metaDataArray: [NoteMetaData]?
    var contentArray: [NoteContent]?
    
    override init() {
        super.init()
        metaDataArray = [NoteMetaData]()
        contentArray = [NoteContent]()
    }
    
    func createNewNote() {
        let newNote = NoteMetaData(context: managedContext!)
        let newContent = NoteContent(context: managedContext!)
        let newUuid = UUID()
        
        newNote.colour = UIColor.cyan
        newNote.dateCreated = Date()
        newNote.dateModified = Date()
        newNote.uuid = newUuid.uuidString
        newNote.content = newContent
        
        newContent.text = "\(newUuid)"
        newContent.uuid = newUuid.uuidString
        
        metaDataArray?.append(newNote)
        save()
    }
}
