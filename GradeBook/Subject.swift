//
//  Subject.swift
//  GradeBook
//
//  Created by Colin Taylor on 3/3/17.
//  Copyright © 2017 Colin Taylor. All rights reserved.
//

import Foundation
import os.log

class Subject: NSObject, NSCoding {
    //MARK: properties
    var name:String = ""
    var abreviation:String = ""
    var assignments = [Assignment]()
    var gradingScale:Int = 100 //points out of. 100 for percentage, 4 for lower grades etc.
    var earnedPoints:Int = 0 //the total points earned for the assignments
    var totalPoints:Int = 0 // total points available for the assignments
    
    //MARK: types
    struct PropertyKey {
        static let name = "name"
        static let abreviation = "abr"
        static let assignments = "assignments"
        static let gradingScale = "gradingScale"
        static let earnedPoints = "earnedPoints"
        static let totalPoints = "totalPoints"
    }
    
    //MARK:initializers
    
    init(name:String, abr:String, gradeScale:Int) {
        super.init()
        self.name = name
        self.abreviation = abr
        self.gradingScale = gradeScale
    }
    init(name:String, abr:String) {
        super.init()
        self.name = name
        self.abreviation = abr
    }

    init?(name:String, abr:String, assignments:[Assignment], gradeScale:Int, earnedPoints:Int, totalPoints:Int) {
        super.init()
        
        self.name = String.init(name)
        self.abreviation = String.init(abr)
        self.assignments = [Assignment]()
        for assignment in assignments {
            self.assignments.append(assignment.copy() as! Assignment)
        }
        self.gradingScale = gradeScale
        self.earnedPoints = earnedPoints
        self.totalPoints = totalPoints
    }
//MARK: Coding functions
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(abreviation, forKey: PropertyKey.abreviation)
        aCoder.encode(assignments, forKey: PropertyKey.assignments)
        aCoder.encode(gradingScale, forKey: PropertyKey.gradingScale)
        aCoder.encode(earnedPoints, forKey: PropertyKey.earnedPoints)
        aCoder.encode(totalPoints, forKey: PropertyKey.totalPoints)
    }
    
    required convenience init?(coder aDecoder:NSCoder) {
        
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("unable to decode the name for a Subject object", log: OSLog.default, type: .debug)
            return nil
        }
        guard let abreviation = aDecoder.decodeObject(forKey: PropertyKey.abreviation) as? String else {
            os_log("unable to decode the abreviation for a Subject object", log: OSLog.default, type: .debug)
            return nil
        }
        let gradingScale = aDecoder.decodeInteger(forKey: PropertyKey.gradingScale)
        
        let assignments = aDecoder.decodeObject(forKey: PropertyKey.assignments) as! [Assignment]
        
        let earnedPoints = aDecoder.decodeInteger(forKey: PropertyKey.earnedPoints)
        
        let totalPoints = aDecoder.decodeInteger(forKey: PropertyKey.totalPoints)

        self.init(name: name, abr: abreviation, assignments: assignments, gradeScale: gradingScale, earnedPoints:earnedPoints, totalPoints:totalPoints)
    }
        
    func addAssingment(newAssignment: Assignment) {
        self.earnedPoints += newAssignment.grade
        self.totalPoints += newAssignment.totalPoints
        
        self.assignments.append(newAssignment)
    }
    
    func displayedGrade()->Int {
        if totalPoints == 0 {
            return gradingScale
        } else {
            return earnedPoints/totalPoints * gradingScale
        }
    }
    
    func subjectDescription()->String {
        let displayedGrade = self.displayedGrade()
        return "\(name) : \(abreviation) Grade: \(displayedGrade)"
    }
    

    func displayAssignments() {
        print("displaying the assignments for this students subjects")
    }
    
    override func mutableCopy() -> Any {
        return Subject.init(name: self.name, abr: self.abreviation, assignments: self.assignments, gradeScale: self.gradingScale, earnedPoints: self.earnedPoints, totalPoints: self.totalPoints) as Any
    }
}
