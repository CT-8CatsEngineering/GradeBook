//
//  AssignmentMO+CoreDataClass.swift
//  GradeBook
//
//  Created by Colin on 5/22/17.
//  Copyright © 2017 Colin Taylor. All rights reserved.
//

import Foundation
import CoreData

@objc(AssignmentMO)
public class AssignmentMO: NSManagedObject {

    func classAverage() ->Float {
        var average:Float = 0
        for grade in grades! {
            average += (grade as! GradeMO).score/Float(totalPoints)
        }
        average = average/Float((grades?.count)!)
                
        return average
    }
}
