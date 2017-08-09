//
//  studentAveragesCell.swift
//  GradeBook
//
//  Created by Colin on 4/11/17.
//  Copyright © 2017 Colin Taylor. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class studentAveragesCell: UITableViewCell {
  
    @IBOutlet weak var averagesStack: UIStackView!
    @IBOutlet weak var studentNameField: UITextView!

    func populateAveragesStack(with student:StudentMO) {
        
        let x = 0
        let height:Int = Int(averagesStack.frame.height)
        let count:CGFloat = CGFloat(student.classroom!.subjects!.count)
        let width:Int = Int(averagesStack.frame.width/count)
        
        for subject in (student.classroom?.subjects)! {
            
            let frame = CGRect(x: x, y: 0, width: width, height: height)
            let subjectView:UIStackView = UIStackView.init(frame: frame)
            subjectView.accessibilityIdentifier = "\((subject as! SubjectMO).name ?? "")"
            subjectView.axis = UILayoutConstraintAxis.vertical
            subjectView.backgroundColor = UIColor.lightGray
            
            let abreviationLabel = UILabel.init()
            abreviationLabel.accessibilityIdentifier = "abreviationLabel"
            abreviationLabel.text = (subject as! SubjectMO).abbreviation
            abreviationLabel.textAlignment = NSTextAlignment.center
            subjectView.addArrangedSubview(abreviationLabel)
            
            let classSubjectAverageLabel = UILabel.init()
            classSubjectAverageLabel.accessibilityIdentifier = "averageLabel"
            
            classSubjectAverageLabel.text = "\((subject as! SubjectMO).displayedGrade())"
            classSubjectAverageLabel.textAlignment = NSTextAlignment.center
            subjectView.addArrangedSubview(classSubjectAverageLabel)
            
            averagesStack.addArrangedSubview(subjectView)
            
        }
    
        averagesStack.distribution = UIStackViewDistribution.fillEqually
        averagesStack.setNeedsDisplay()
    }
    func updateAveragesStack(with student:StudentMO) {
        let averagesSubviews = averagesStack.subviews
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext = appDelegate.persistentContainer.viewContext

        for view in averagesSubviews {
            
            let subjectfetchRequest = NSFetchRequest<SubjectMO>(entityName: "SubjectMO")
            subjectfetchRequest.predicate = NSPredicate(format: "name == %@ AND classroom == %@", view.accessibilityIdentifier!, student.classroom!)
            var fetchedSubjects:[SubjectMO] = [SubjectMO]()
            do {
                fetchedSubjects = try managedContext.fetch(subjectfetchRequest)
            } catch {
                fatalError("Failed to fetch Subjects: \(error)")
            }
            var subject:SubjectMO? = nil
            if fetchedSubjects.count == 1 {
                subject = fetchedSubjects[0]
            } else {
                print("this should not happen there should only be one matching subject for a classroom")
                subject = fetchedSubjects[0]
            }
            
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
