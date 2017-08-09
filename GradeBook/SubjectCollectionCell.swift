//
//  SubjectCollectionCell.swift
//  GradeBook
//
//  Created by Colin Taylor on 3/27/17.
//  Copyright © 2017 Colin Taylor. All rights reserved.
//

import Foundation
import UIKit

class subjectCell: UICollectionViewCell {

    @IBOutlet weak var SubjectScale: UILabel!
    @IBOutlet weak var SubjectName: UILabel!
    
    weak var subjectObject:SubjectTemplateMO? = nil
    
    func setSelected(inBool: Bool) {
        if inBool {
            self.backgroundColor = UIColor.init(hue: 0.611111, saturation: 0.8, brightness: 1, alpha: 1)
        } else {
            self.backgroundColor = UIColor.white
        }
    }
}
