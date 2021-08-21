//
//  Note+CoreDataProperties.swift
//  Signary
//
//  Created by Ameya Bhagat on 18/08/21.
//
//

import Foundation
import CoreData


extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var attributedBody: NSAttributedString?
    @NSManaged public var body: String?
    @NSManaged public var color: NSObject?
    @NSManaged public var dateCreated: Date?
    @NSManaged public var dateModified: Date?
    @NSManaged public var isClear: Bool
    @NSManaged public var isPinned: Bool
    @NSManaged public var isTrashed: Bool
    @NSManaged public var title: String?
    @NSManaged public var uuid: String?

}

extension Note : Identifiable {

}
