//
//  Assignment.swift
//  GradeBook
//
//  Created by Colin Taylor on 3/3/17.
//  Copyright © 2017 Colin Taylor. All rights reserved.
//

import Foundation

class Assignment: NSObject, NSCoding {
    var title:String = ""
    //description is covered by NSObject and it got cranky about overriding it
    //weak var subject:Subject?
    var totalPoints:Int = 0
    var grade:Int = 0
    
    //MARK: types
    struct PropertyKey {
        static let title = "title"
        static let totalPoints = "totalPoints"
        static let grade = "grade"
    }

    override init() {//Temporary placeholder! this is not a useful init right now.
        //subject = Subject.init(name: "temp", abr: "t")
        
        super.init()
    }
    init(title:String, grade:Int, totalPoints:Int) {
        self.title = String.init(stringLiteral: title)
        self.grade = grade
        self.totalPoints = totalPoints
        //self.subject = subject
        
        super.init()
        
        
    }
    override func mutableCopy() -> Any {
        return Assignment.init(title: self.title, grade: self.grade, totalPoints: self.totalPoints) as Any
    }
    //MARK: Coding functions
    func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: PropertyKey.title)
        aCoder.encode(totalPoints, forKey: PropertyKey.totalPoints)
        aCoder.encode(grade, forKey: PropertyKey.grade)
    }
    
    required convenience init?(coder aDecoder:NSCoder) {
        let title:String = aDecoder.decodeObject(forKey: PropertyKey.title) as! String
        let totalPoints:Int = aDecoder.decodeInteger(forKey: PropertyKey.totalPoints)
        let grade:Int = aDecoder.decodeInteger(forKey: PropertyKey.grade)
        
        self.init(title: title, grade: grade, totalPoints: totalPoints)
    }

}
