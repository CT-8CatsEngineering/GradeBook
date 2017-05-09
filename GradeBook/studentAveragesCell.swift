//
//  studentAveragesCell.swift
//  GradeBook
//
//  Created by Colin on 4/11/17.
//  Copyright © 2017 Colin Taylor. All rights reserved.
//

import Foundation
import UIKit

class studentAveragesCell: UITableViewCell {
  
    @IBOutlet weak var averagesStack: UIStackView!
    @IBOutlet weak var studentNameField: UITextView!

    func populateAveragesStack(with student:Student) {
        
        let x = 0
        let height:Int = Int(averagesStack.frame.height)
        let count:CGFloat = CGFloat(student.subjects.count)
        let width:Int = Int(averagesStack.frame.width/count)
        
        for (_, subject) in student.subjects {
            
            let frame = CGRect(x: x, y: 0, width: width, height: height)
            let subjectView:UIStackView = UIStackView.init(frame: frame)
            subjectView.accessibilityIdentifier = "\(subject.name)"
            subjectView.axis = UILayoutConstraintAxis.vertical
            subjectView.backgroundColor = UIColor.lightGray
            
            let abreviationLabel = UILabel.init()
            abreviationLabel.accessibilityIdentifier = "abreviationLabel"
            abreviationLabel.text = subject.abreviation
            abreviationLabel.textAlignment = NSTextAlignment.center
            subjectView.addArrangedSubview(abreviationLabel)
            
            let classSubjectAverageLabel = UILabel.init()
            classSubjectAverageLabel.accessibilityIdentifier = "averageLabel"
            
            classSubjectAverageLabel.text = "\(subject.displayedGrade())"
            classSubjectAverageLabel.textAlignment = NSTextAlignment.center
            subjectView.addArrangedSubview(classSubjectAverageLabel)
            
            averagesStack.addArrangedSubview(subjectView)
            
        }
    
        averagesStack.distribution = UIStackViewDistribution.fillEqually
        averagesStack.setNeedsDisplay()
        print("average stack views \(averagesStack.arrangedSubviews)")
    }
    func updateAveragesStack(with student:Student) {
        let averagesSubviews = averagesStack.subviews
        
        for view in averagesSubviews {
            let subject = student.subjects[view.accessibilityIdentifier!]
            let labelSubviews = view.subviews
            for subview in labelSubviews {
                let labelSubview = subview as! UILabel
                if labelSubview.accessibilityIdentifier == "averageLabel" {
                    let grade = subject!.displayedGrade()
                    var averageGradeString:String = "\(grade)"
                    if averageGradeString == "100" {
                        averageGradeString = "N/A"
                    }
                    
                    labelSubview.text = averageGradeString
                }
            }
        }
        averagesStack.distribution = UIStackViewDistribution.fillEqually
        averagesStack.setNeedsDisplay()

    }

}
