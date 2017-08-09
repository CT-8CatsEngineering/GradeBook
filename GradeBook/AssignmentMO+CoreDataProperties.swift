//
//  AssignmentMO+CoreDataProperties.swift
//  GradeBook
//
//  Created by Colin on 5/22/17.
//  Copyright © 2017 Colin Taylor. All rights reserved.
//

import Foundation
import CoreData


extension AssignmentMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AssignmentMO> {
        return NSFetchRequest<AssignmentMO>(entityName: "AssignmentMO")
    }

    @NSManaged public var name: String?
    @NSManaged public var status: Bool
    @NSManaged public var totalPoints: Int64
    @NSManaged public var subject: SubjectMO?
    @NSManaged public var grades: NSOrderedSet?

}

// MARK: Generated accessors for grades
extension AssignmentMO {

    @objc(insertObject:inGradesAtIndex:)
    @NSManaged public func insertIntoGrades(_ value: GradeMO, at idx: Int)

    @objc(removeObjectFromGradesAtIndex:)
    @NSManaged public func removeFromGrades(at idx: Int)

    @objc(insertGrades:atIndexes:)
    @NSManaged public func insertIntoGrades(_ values: [GradeMO], at indexes: NSIndexSet)

    @objc(removeGradesAtIndexes:)
    @NSManaged public func removeFromGrades(at indexes: NSIndexSet)

    @objc(replaceObjectInGradesAtIndex:withObject:)
    @NSManaged public func replaceGrades(at idx: Int, with value: GradeMO)

    @objc(replaceGradesAtIndexes:withGrades:)
    @NSManaged public func replaceGrades(at indexes: NSIndexSet, with values: [GradeMO])

    @objc(addGradesObject:)
    @NSManaged public func addToGrades(_ value: GradeMO)

    @objc(removeGradesObject:)
    @NSManaged public func removeFromGrades(_ value: GradeMO)

    @objc(addGrades:)
    @NSManaged public func addToGrades(_ values: NSOrderedSet)

    @objc(removeGrades:)
    @NSManaged public func removeFromGrades(_ values: NSOrderedSet)

}
