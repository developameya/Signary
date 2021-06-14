//
//  NoteContent+CoreDataProperties.swift
//  Signary
//
//  Created by Ameya Bhagat on 14/06/21.
//
//

import Foundation
import CoreData


extension NoteContent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NoteContent> {
        return NSFetchRequest<NoteContent>(entityName: "NoteContent")
    }

    @NSManaged public var image: Data?
    @NSManaged public var text: String?
    @NSManaged public var uuid: String?
    @NSManaged public var metaData: NoteMetaData?

}

extension NoteContent : Identifiable {

}
