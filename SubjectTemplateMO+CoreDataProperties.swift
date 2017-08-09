//
//  SubjectTemplateMO+CoreDataProperties.swift
//  GradeBook
//
//  Created by Colin on 8/7/17.
//  Copyright © 2017 Colin Taylor. All rights reserved.
//

import Foundation
import CoreData


extension SubjectTemplateMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SubjectTemplateMO> {
        return NSFetchRequest<SubjectTemplateMO>(entityName: "SubjectTemplateMO")
    }

    @NSManaged public var name: String?
    @NSManaged public var abbreviation: String?
    @NSManaged public var gradeScale: Float

}
