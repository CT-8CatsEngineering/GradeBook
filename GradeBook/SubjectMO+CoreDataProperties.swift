//
//  SubjectMO+CoreDataProperties.swift
//  GradeBook
//
//  Created by Colin on 5/22/17.
//  Copyright © 2017 Colin Taylor. All rights reserved.
//

import Foundation
import CoreData


extension SubjectMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SubjectMO> {
        return NSFetchRequest<SubjectMO>(entityName: "SubjectMO")
    }

    @NSManaged public var abbreviation: String?
    @NSManaged public var gradeScale: Float
    @NSManaged public var name: String?
    @NSManaged public var assignments: NSOrderedSet?
    @NSManaged public var classroom: ClassroomMO?

}

// MARK: Generated accessors for assignments
extension SubjectMO {

    @objc(insertObject:inAssignmentsAtIndex:)
    @NSManaged public func insertIntoAssignments(_ value: AssignmentMO, at idx: Int)

    @objc(removeObjectFromAssignmentsAtIndex:)
    @NSManaged public func removeFromAssignments(at idx: Int)

    @objc(insertAssignments:atIndexes:)
    @NSManaged public func insertIntoAssignments(_ values: [AssignmentMO], at indexes: NSIndexSet)

    @objc(removeAssignmentsAtIndexes:)
    @NSManaged public func removeFromAssignments(at indexes: NSIndexSet)

    @objc(replaceObjectInAssignmentsAtIndex:withObject:)
    @NSManaged public func replaceAssignments(at idx: Int, with value: AssignmentMO)

    @objc(replaceAssignmentsAtIndexes:withAssignments:)
    @NSManaged public func replaceAssignments(at indexes: NSIndexSet, with values: [AssignmentMO])

    @objc(addAssignmentsObject:)
    @NSManaged public func addToAssignments(_ value: AssignmentMO)

    @objc(removeAssignmentsObject:)
    @NSManaged public func removeFromAssignments(_ value: AssignmentMO)

    @objc(addAssignments:)
    @NSManaged public func addToAssignments(_ values: NSOrderedSet)

    @objc(removeAssignments:)
    @NSManaged public func removeFromAssignments(_ values: NSOrderedSet)

}
