//
//  Logic.swift
//  Signary
//
//  Created by Ameya Bhagat on 12/06/21.
//

import Foundation

///This class provides the logic to load appropriate data as called by the app.
class Logic: DataManager {
    var metaDataArray: [NoteMetaData]?
    var contentArray: [NoteContent]?
    
    override init() {
        super.init()
        metaDataArray = [NoteMetaData]()
        contentArray = [NoteContent]()
    }
    
}
