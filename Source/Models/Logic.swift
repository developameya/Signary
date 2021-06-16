//
//  Logic.swift
//  Signary
//
//  Created by Ameya Bhagat on 12/06/21.
//

import Foundation
import UIKit

///This class provides the logic to load appropriate data as called by the app.
public class Logic: DataManager {
    var metaDataArray: [NoteMetaData]?
    var contentArray: [NoteContent]?
    var fetchedContent: NoteContent?
    
    override init() {
        super.init()
        updateData()
    }
    
    func updateData() {
        metaDataArray = loadMetaData()
        contentArray = loadContent()
    }
    
    func createNewNote() {
        let newNote = NoteMetaData(context: managedContext!)
        let newContent = NoteContent(context: managedContext!)
        let newUuid = UUID()
        
        newNote.colour = UIColor.random()
        newNote.dateCreated = Date()
        newNote.dateModified = Date()
        newNote.uuid = newUuid.uuidString
        newNote.content = newContent
        
        newContent.text = "\(newUuid)"
        newContent.uuid = newUuid.uuidString
        
        metaDataArray?.append(newNote)
        contentArray?.append(newContent)
        save()
    }
    
    func fetchNote(at indexPath: IndexPath) {
        fetchedContent =  metaDataArray![indexPath.row].content
    }
    
    func clearEmptyNote(textView: UITextView) {
        guard let safeContent = contentArray?.last else {fatalError()}
         if (textView.text == "" || textView.text.hasPrefix(" ") == true) {
            safeContent.metaData?.isClear = true
            deleteFromStore(metaData: safeContent.metaData!, content: safeContent)
         } else {
            safeContent.metaData?.isClear = false
            save()
         }
     }
}
