//
//  ClassTableViewCell.swift
//  GradeBook
//
//  Created by Colin Taylor on 3/29/17.
//  Copyright © 2017 Colin Taylor. All rights reserved.
//

import Foundation
import UIKit

class ClassTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var ClassNameView: UILabel!
    @IBOutlet weak var StudentNumber: UILabel!
    
    weak var classObject:ClassroomMO?
    
}
