//
//  NoteMetaData+CoreDataProperties.swift
//  Signary
//
//  Created by Ameya Bhagat on 14/06/21.
//
//

import Foundation
import CoreData


extension NoteMetaData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NoteMetaData> {
        return NSFetchRequest<NoteMetaData>(entityName: "NoteMetaData")
    }

    @NSManaged public var colour: NSObject?
    @NSManaged public var dateCreated: Date?
    @NSManaged public var dateModified: Date?
    @NSManaged public var isClear: Bool
    @NSManaged public var isPinned: Bool
    @NSManaged public var isTrashed: Bool
    @NSManaged public var uuid: String?
    @NSManaged public var content: NoteContent?

}

extension NoteMetaData : Identifiable {

}
