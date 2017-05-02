//
//  StudentAssignmentCell.swift
//  GradeBook
//
//  Created by Colin on 4/13/17.
//  Copyright © 2017 Colin Taylor. All rights reserved.
//

import Foundation
import UIKit

class StudentAssignmentCell: UITableViewCell {
    @IBOutlet weak var gradeField: UITextField!
    @IBOutlet weak var assignmentStudentName: UILabel!
    @IBOutlet weak var totalPoints: UILabel!
    
    weak var studentObj:Student?
}
