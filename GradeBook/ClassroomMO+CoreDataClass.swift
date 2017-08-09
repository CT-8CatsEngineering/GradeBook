//
//  ClassroomMO+CoreDataClass.swift
//  GradeBook
//
//  Created by Colin on 5/22/17.
//  Copyright © 2017 Colin Taylor. All rights reserved.
//

import Foundation
import CoreData

@objc(ClassroomMO)
public class ClassroomMO: NSManagedObject {
    func calculateWholeClassAverages() -> [SubjectMO:Int] {
        if (subjects?.count == 0) {
            //this is a problem the classroom is not properly set up.
            return [SubjectMO:Int]() //returns an empty array
        } else if (students?.count == 0) {
            var emptyAverages = [SubjectMO:Int]()
            for nextSubject in subjects! {
                emptyAverages[nextSubject as! SubjectMO] = 0
            }
            return emptyAverages
        } else {
            var averages = [SubjectMO:Int]() //
            for subject in subjects! {
                averages[(subject as! SubjectMO)] = ((subject as! SubjectMO).displayedGrade() )
            }
            return averages
        }
    }

}
