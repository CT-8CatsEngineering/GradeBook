//
//  Assignment.swift
//  GradeBook
//
//  Created by Colin Taylor on 3/3/17.
//  Copyright © 2017 Colin Taylor. All rights reserved.
//

import Foundation

class Assignment: NSObject {
    var title:String = ""
    //description is covered by NSObject and it got cranky about overriding it
    weak var subject:Subject?
    var totalPoints:Int = 0
    var grade:Int = 0
    
    override init() {//Temporary placeholder! this is not a useful init right now.
        subject = Subject.init(name: "temp", abr: "t")
        
        super.init()
    }
    init(title:String, subject:Subject, grade:Int, totalPoints:Int) {
        self.title = String.init(stringLiteral: title)
        self.grade = grade
        self.totalPoints = totalPoints
        self.subject = subject
        
        super.init()
        
        
    }
    override func mutableCopy() -> Any {
        return Assignment.init(title: self.title, subject: self.subject!, grade: self.grade, totalPoints: self.totalPoints) as Any
    }
}
