//
//  Student.swift
//  GradeBook
//
//  Created by Colin Taylor on 3/3/17.
//  Copyright © 2017 Colin Taylor. All rights reserved.
//

import Foundation

class Student:NSObject, NSCoding {
    
    var name:String
    var id:Int
    var subjects = [String:Subject]()//[subject.name:subject]  allows us to directly access each subject by its name which allows for coresponding between the students.subject and Classroom.subjects
    var subjectsArray = [Subject]()
    //weak var classroom:Classroom?
    
    //MARK: types
    struct PropertyKey {
        static let name = "name"
        static let id = "id"
        static let subjects = "subjects"
    }

    override init() {//temporary placeholder not really useful.
        self.name = ""
        self.id = 0
        //self.classroom = Classroom.init(name: "empty")
        super.init()
        
    }
    
    init(name:String, inID:Int) {
        self.name = String.init(name)
        self.id = inID
        //self.classroom = inClass
    }
    
    func setSubjects(inSubjectArray:[Subject]) {
        var tempDict = [String:Subject]()
        for inSubject in inSubjectArray {
            tempDict[inSubject.name] = (inSubject.mutableCopy() as! Subject)
        }
        subjectsArray = inSubjectArray
        subjects = tempDict
    }
    
    override func mutableCopy() -> Any {
        let newStudent:Student = Student.init(name: self.name, inID: self.id)
        var copySubjectArray = [Subject]()
        for subject in subjectsArray {
            copySubjectArray.append(subject.mutableCopy() as! Subject)
        }
        newStudent.setSubjects(inSubjectArray: copySubjectArray)
        return newStudent
    }
    //MARK: Coding functions
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(id, forKey: PropertyKey.id)
        aCoder.encode(subjectsArray, forKey: PropertyKey.subjects)
        
    }
    
    required convenience init?(coder aDecoder:NSCoder) {
        let name:String = aDecoder.decodeObject(forKey: PropertyKey.name) as! String
        let id:Int = aDecoder.decodeInteger(forKey: PropertyKey.id)
        let subjects:[Subject] = aDecoder.decodeObject(forKey: PropertyKey.subjects) as! [Subject]
        
        self.init(name: name, inID: id)
        self.setSubjects(inSubjectArray: subjects)
        
        
    }

    
}
