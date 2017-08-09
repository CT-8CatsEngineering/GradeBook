//
//  Grade.swift
//  GradeBook
//
//  Created by Colin on 5/10/17.
//  Copyright © 2017 Colin Taylor. All rights reserved.
//

import Foundation

class Grade: NSObject, NSCoding {
    
    var totalPoints:Int = 0
    var grade:Int = 0

    //MARK: types
    struct PropertyKey {
        static let title = "title"
        static let totalPoints = "totalPoints"
        static let grade = "grade"
    }
    override func mutableCopy() -> Any {
        return "" as Any
    }
    //MARK: Coding functions
    func encode(with aCoder: NSCoder) {
//        aCoder.encode(title, forKey: PropertyKey.title)
    }
    
    required convenience init?(coder aDecoder:NSCoder) {
//        let title:String = aDecoder.decodeObject(forKey: PropertyKey.title) as! String
        self.init()
    }

}
