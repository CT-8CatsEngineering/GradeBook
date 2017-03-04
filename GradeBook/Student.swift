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
    var assignments = [String: Array<Any>]()
    var classroom:Classroom
    
    override init() {//temporary placeholder not really useful.
        self.name = ""
        self.id = 0
        self.classroom = Classroom.init(name: "empty")
        super.init()
        
    }
}
