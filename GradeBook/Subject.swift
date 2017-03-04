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
    
    //MARK: types
    struct PropertyKey {
        static let name = "name"
        static let abreviation = "abr"
        static let assignments = "assignments"
        static let gradingScale = "gradingScale"
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

    init?(name:String, abr:String, assignments:[Assignment], gradeScale:Int) {
        super.init()
        
        self.name = name
        self.abreviation = abr
        self.assignments = assignments
        self.gradingScale = gradeScale
    }
//MARK: Coding functions
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(abreviation, forKey: PropertyKey.abreviation)
        aCoder.encode(assignments, forKey: PropertyKey.assignments)
        aCoder.encode(gradingScale, forKey: PropertyKey.gradingScale)
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
        
        
        self.init(name: name, abr: abreviation, assignments: assignments, gradeScale: gradingScale)
        
    }
}
