//
//  StudentListCell.swift
//  GradeBook
//
//  Created by Colin Taylor on 3/29/17.
//  Copyright © 2017 Colin Taylor. All rights reserved.
//

import Foundation
import UIKit

class StudentListCell: UITableViewCell {
    
    @IBOutlet weak var studentNameField: UITextField!
    weak var controller:NewClassViewController?
    var position:Int?

    @IBAction func updateStudentName(_ sender: Any) {
        controller?.updateStudentName(inName: studentNameField.text!, position: position!)
    }
}
