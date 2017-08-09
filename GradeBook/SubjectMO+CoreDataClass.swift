//
//  SubjectMO+CoreDataClass.swift
//  GradeBook
//
//  Created by Colin on 5/22/17.
//  Copyright © 2017 Colin Taylor. All rights reserved.
//

import Foundation
import CoreData

@objc(SubjectMO)
public class SubjectMO: NSManagedObject {

    func displayedGrade()->Int {
        if assignments?.count == 0 {
            return Int(gradeScale)
        } else {
            var floatEarnedPoints:Float = 0
            for assignmentMO in assignments! {
                floatEarnedPoints += (assignmentMO as! AssignmentMO).classAverage()
            }
            floatEarnedPoints = floatEarnedPoints/Float((assignments?.count)!)
            return Int(floatEarnedPoints * gradeScale)
        }
    }
    
    func displayedGradeForStudent(student:StudentMO)->Int {
        if assignments?.count == 0 {
            return Int(gradeScale)
        } else {
            var floatEarnedPoints:Float = 0
            for assignmentMO in assignments! {
                floatEarnedPoints += (assignmentMO as! AssignmentMO).classAverage()
            }
            floatEarnedPoints = floatEarnedPoints/Float((assignments?.count)!)
            return Int(floatEarnedPoints * gradeScale)
        }
    }
    func subjectDescription()->String {
        let displayedGrade = self.displayedGrade()
        return "\(name ?? "") : \(abbreviation ?? "") Grade: \(displayedGrade)"
    }
    
    
    func displayAssignments() {
        print("displaying the assignments for this students subjects")
    }

}
