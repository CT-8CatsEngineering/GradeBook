//
//  ClassroomMO+CoreDataProperties.swift
//  GradeBook
//
//  Created by Colin on 5/22/17.
//  Copyright © 2017 Colin Taylor. All rights reserved.
//

import Foundation
import CoreData


extension ClassroomMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ClassroomMO> {
        return NSFetchRequest<ClassroomMO>(entityName: "ClassroomMO")
    }

    @NSManaged public var name: String?
    @NSManaged public var students: NSOrderedSet?
    @NSManaged public var subjects: NSOrderedSet?

}

// MARK: Generated accessors for students
extension ClassroomMO {

    @objc(insertObject:inStudentsAtIndex:)
    @NSManaged public func insertIntoStudents(_ value: StudentMO, at idx: Int)

    @objc(removeObjectFromStudentsAtIndex:)
    @NSManaged public func removeFromStudents(at idx: Int)

    @objc(insertStudents:atIndexes:)
    @NSManaged public func insertIntoStudents(_ values: [StudentMO], at indexes: NSIndexSet)

    @objc(removeStudentsAtIndexes:)
    @NSManaged public func removeFromStudents(at indexes: NSIndexSet)

    @objc(replaceObjectInStudentsAtIndex:withObject:)
    @NSManaged public func replaceStudents(at idx: Int, with value: StudentMO)

    @objc(replaceStudentsAtIndexes:withStudents:)
    @NSManaged public func replaceStudents(at indexes: NSIndexSet, with values: [StudentMO])

    @objc(addStudentsObject:)
    @NSManaged public func addToStudents(_ value: StudentMO)

    @objc(removeStudentsObject:)
    @NSManaged public func removeFromStudents(_ value: StudentMO)

    @objc(addStudents:)
    @NSManaged public func addToStudents(_ values: NSOrderedSet)

    @objc(removeStudents:)
    @NSManaged public func removeFromStudents(_ values: NSOrderedSet)

}

// MARK: Generated accessors for subjects
extension ClassroomMO {

    @objc(insertObject:inSubjectsAtIndex:)
    @NSManaged public func insertIntoSubjects(_ value: SubjectMO, at idx: Int)

    @objc(removeObjectFromSubjectsAtIndex:)
    @NSManaged public func removeFromSubjects(at idx: Int)

    @objc(insertSubjects:atIndexes:)
    @NSManaged public func insertIntoSubjects(_ values: [SubjectMO], at indexes: NSIndexSet)

    @objc(removeSubjectsAtIndexes:)
    @NSManaged public func removeFromSubjects(at indexes: NSIndexSet)

    @objc(replaceObjectInSubjectsAtIndex:withObject:)
    @NSManaged public func replaceSubjects(at idx: Int, with value: SubjectMO)

    @objc(replaceSubjectsAtIndexes:withSubjects:)
    @NSManaged public func replaceSubjects(at indexes: NSIndexSet, with values: [SubjectMO])

    @objc(addSubjectsObject:)
    @NSManaged public func addToSubjects(_ value: SubjectMO)

    @objc(removeSubjectsObject:)
    @NSManaged public func removeFromSubjects(_ value: SubjectMO)

    @objc(addSubjects:)
    @NSManaged public func addToSubjects(_ values: NSOrderedSet)

    @objc(removeSubjects:)
    @NSManaged public func removeFromSubjects(_ values: NSOrderedSet)

}
