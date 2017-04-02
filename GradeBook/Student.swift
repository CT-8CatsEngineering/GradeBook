//
//  Student.swift
//  GradeBook
//
//  Created by Colin Taylor on 3/3/17.
//  Copyright © 2017 Colin Taylor. All rights reserved.
//

import Foundation

class Student:NSObject {
    
    var name:String
    var id:Int
    var subjects = [String:Subject]()//[subject.name:subject]  allows us to directly access each subject by its name which allows for coresponding between the students.subject and Classroom.subjects
    weak var classroom:Classroom?
    
    override init() {//temporary placeholder not really useful.
        self.name = ""
        self.id = 0
        self.classroom = Classroom.init(name: "empty")
        super.init()
        
    }
    
    init(name:String, inID:Int, inClass:Classroom) {
        self.name = name
        self.id = inID
        self.classroom = inClass
    }
    
    func setSubjects(inSubjectArray:[Subject]) {
        var tempDict = [String:Subject]()
        for inSubject in inSubjectArray {
            tempDict[inSubject.name] = inSubject
        }
        
        subjects = tempDict
    }
}
