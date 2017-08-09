//
//  GradeMO+CoreDataProperties.swift
//  GradeBook
//
//  Created by Colin on 5/22/17.
//  Copyright © 2017 Colin Taylor. All rights reserved.
//

import Foundation
import CoreData


extension GradeMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GradeMO> {
        return NSFetchRequest<GradeMO>(entityName: "GradeMO")
    }

    @NSManaged public var score: Float
    @NSManaged public var assignment: AssignmentMO?
    @NSManaged public var student: StudentMO?

}
