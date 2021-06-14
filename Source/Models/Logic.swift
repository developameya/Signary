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
        newNote.colour = UIColor.cyan
        newNote.dateCreated = Date()
        newNote.dateModified = Date()
        let newUuid = UUID()
        newNote.uuid = newUuid
        let newContent = NoteContent(context: managedContext!)
        newContent.text = "\(newUuid)"
        newNote.content = newContent
        metaDataArray?.append(newNote)
        save()
    }
}
