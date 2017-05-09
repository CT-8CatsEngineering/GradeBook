//
//  Classroom.swift
//  GradeBook
//
//  Created by Colin Taylor on 3/3/17.
//  Copyright © 2017 Colin Taylor. All rights reserved.
//

import Foundation
import UIKit

class Classroom: NSObject, NSCoding {
//MARK: properties
    var className:String = ""
    var subjects = [Subject]() //used as the basis for each students subject array
    var students = [Student]()
    var classAverages:Dictionary = [Subject: Int]()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //MARK: types
    struct PropertyKey {
        static let classname = "className"
        static let subjects = "subjects"
        static let students = "students"
        static let classAverages = "classAverages"
    }

//MARK: Functions
    init(name:String) {
        super.init()
        
        className = name
        
        for subject in subjects {
            classAverages[subject] = 0
        }
        
    }
    
    func setSubjects(array: [Subject]) {
        subjects = array
        for subject in subjects {
            classAverages[subject] = 0
        }
    }
    func addSubject(newSubject: Subject) {
        subjects.append(newSubject)
        classAverages[newSubject] = 0
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
            let studentCount = Float(students.count)
            var classTotal:Float = 0
            var averages = [Subject:Int]() //
            for subject in subjects {
                averages[subject] = 0
            }
            for eachSubject in subjects {
                classTotal = 0
                for eachStudent in students {
                    let studentPoints:Float = Float((eachStudent.subjects[eachSubject.name]?.earnedPoints)!)
                    let studentTotal:Float =  Float((eachStudent.subjects[eachSubject.name]?.totalPoints)!)
                    if studentTotal != 0 {
                        classTotal = (classTotal + (studentPoints.divided(by: studentTotal)))
                    }
                }
                averages[eachSubject] = Int((classTotal/studentCount)*Float(eachSubject.gradingScale))
            }
            return averages
        }
    }
    func saveClassroom() {
        let fileManager = FileManager.default
        var saveFile:URL =  appDelegate.classroomSaveFilePath()
        let dirPathExists:Bool = fileManager.fileExists(atPath: saveFile.path)
        saveFile.appendPathComponent(self.className)
        let filePath = saveFile.path
        let filePathExists:Bool = fileManager.fileExists(atPath: filePath)
        //let data = NSKeyedArchiver.archivedData(withRootObject: self)
        //   let success = data.writ
        print("dir path:\(dirPathExists), filePathExists: \(filePathExists) filePath:\(filePath)")
        let success = NSKeyedArchiver.archiveRootObject(self, toFile: filePath)
        if !success {
            print("failed to save the class to file.")
        }
    }
    
    
    //MARK: Coding functions
    func encode(with aCoder: NSCoder) {
        aCoder.encode(className, forKey: PropertyKey.classname)
        aCoder.encode(subjects, forKey: PropertyKey.subjects)
        aCoder.encode(students, forKey: PropertyKey.students)
        //aCoder.encode(classAverages, forKey: PropertyKey.classAverages)
    }
    
    required convenience init?(coder aDecoder:NSCoder) {
        self.init(name: aDecoder.decodeObject(forKey: PropertyKey.classname) as! String)
        self.setSubjects(array: aDecoder.decodeObject(forKey: PropertyKey.subjects) as! [Subject])
        self.setStudents(array: aDecoder.decodeObject(forKey: PropertyKey.students) as! [Student])
        
        classAverages = self.recalculateWholeClassAverages()
    }
}
