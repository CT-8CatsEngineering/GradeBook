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
    var subjects = [Subject]() //used as the basis for each students subject array
    var students = [Student]()
    var classAverages:Dictionary = [Subject: Int]()
    
    
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
    
    func recalculateWholeClassAverages() -> [Subject:Int] {
        if (subjects.count == 0) {
            //this is a problem the classroom is not properly set up.
            return [Subject:Int]() //returns an empty array
        } else if (students.count == 0) {
            var emptyAverages = [Subject:Int]()
            for nextSubject in subjects {
                emptyAverages[nextSubject] = 0
            }
            return emptyAverages
        } else {
            let studentCount = students.count
            var averages = [Subject:Int]() //
            for eachSubject in subjects {
                for eachStudent in students {
                    let studentPoints:Int = (eachStudent.subjects[eachSubject.name]?.earnedPoints)!
                    let studentTotal:Int =  (eachStudent.subjects[eachSubject.name]?.totalPoints)!
                    averages[eachSubject] = (averages[eachSubject]!+(studentPoints/studentTotal))/studentCount
                }
            }
            return averages
        }
    }
    
}
