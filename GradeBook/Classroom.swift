//
//  Classroom.swift
//  GradeBook
//
//  Created by Colin Taylor on 3/3/17.
//  Copyright © 2017 Colin Taylor. All rights reserved.
//

import Foundation

class Classroom: NSObject {
//MARK: properties
    var className:String = ""
    var subjects = [Subject]()
    var students = [Student]()

    
    
//MARK: Functions
    init(name:String) {
        super.init()
        
        className = name
    }
    
    func setSubjects(array: [Subject]) {
        subjects = array
    }
    func addSubject(newSubject: Subject) {
        subjects.append(newSubject)
    }
    func setStudents(array: [Student]) {
        students = array
    }
    func addStudent(newStudent: Student){
        students.append(newStudent)
    }
    
}
