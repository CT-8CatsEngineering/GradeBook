//
//  NewStudentCell.swift
//  GradeBook
//
//  Created by Colin Taylor on 3/29/17.
//  Copyright © 2017 Colin Taylor. All rights reserved.
//

import Foundation
import UIKit

class NewStudentCell: UITableViewCell {
    
    @IBOutlet weak var studentNameField: UITextField!
    weak var controller:NewClassViewController?
    
    @IBAction func addStudentName(_ sender: Any) {
        if studentNameField.text! != "" {
            controller?.students.append(studentNameField.text!)
            controller?.studentListView.reloadSections(IndexSet.init(integer: 1), with: UITableViewRowAnimation.automatic)
        }
        studentNameField.text = ""
    }
}
