//
//  ClassroomViewController.swift
//  GradeBook
//
//  Created by Colin on 4/10/17.
//  Copyright © 2017 Colin Taylor. All rights reserved.
//

import Foundation
import UIKit

class ClassroomViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var assignmentButton: UIBarButtonItem!
    @IBOutlet weak var classListButton: UIBarButtonItem!
    @IBOutlet weak var classAveragesStack: UIStackView!
    var classroom:Classroom?
    var lastAssignmentID:Int = 0
    
    @IBOutlet weak var studentTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if (classroom != nil) {
            print("classroom is not nil \(String(describing: classroom?.className))")
            self.setUpClassAverageStack()
        }
        print("class average stack views \(classAveragesStack.arrangedSubviews)")
        studentTableView.reloadData()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "addAssignmentSegue" {
            print("going to the add assignment panel")
            let navControl = segue.destination as? UINavigationController
            //let newAssignmentController = segue.destination as! CreateAssignmentViewController
            guard let newAssignmentController = navControl?.topViewController as? CreateAssignmentViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            var tempStudents = [Student]()
            for newstudent in (classroom?.students)! {
                tempStudents.append(newstudent.mutableCopy() as! Student)
            }
            newAssignmentController.students = tempStudents
            newAssignmentController.classSubjects = (classroom?.subjects)!
                        
        }else if segue.identifier == "viewStudentDetailsSegue" {
            print("going to the student details panel")
        } else {
            print("neither the assignment button nor the student detail was pressed, going back to the list of classes")
        }
        
    }
    func setUpClassAverageStack() {
        let x = 0
        let height:Int = Int(classAveragesStack.frame.height)
        let count:CGFloat = CGFloat((classroom?.subjects.count)!)
        let width:Int = Int(classAveragesStack.frame.width/count)
        
        for (subject, score) in (classroom?.classAverages)! {
            
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
            classSubjectAverageLabel.text = "\(score)"
            classSubjectAverageLabel.textAlignment = NSTextAlignment.center
            subjectView.addArrangedSubview(classSubjectAverageLabel)
            
            classAveragesStack.addArrangedSubview(subjectView)
            
        }
        classAveragesStack.distribution = UIStackViewDistribution.fillEqually
        classAveragesStack.setNeedsDisplay()

    }
    func updateClassAverageStack() {
        classroom?.classAverages = (classroom?.recalculateWholeClassAverages())!
        
        let averagesSubviews = classAveragesStack.subviews
        
        for view in averagesSubviews {
            var subject:Subject? = nil
            for (testSubject, _) in (classroom?.classAverages)! {
                if testSubject.name == view.accessibilityIdentifier! {
                    subject = testSubject
                }
            }
            
            if subject != nil { //if we found a matching subject we can update the view.
                let labelSubviews = view.subviews
                for subview in labelSubviews {
                    let labelSubview = subview as! UILabel
                    if labelSubview.accessibilityIdentifier == "averageLabel" {
                        var averageGradeString:String = "\(subject!.displayedGrade())"
                        if averageGradeString == "100" {
                            averageGradeString = "N/A"
                        }
                        
                        labelSubview.text = averageGradeString
                    }
                }
            }
            
        }
        classAveragesStack.distribution = UIStackViewDistribution.fillEqually
        classAveragesStack.setNeedsDisplay()
        
    }
    @IBAction func unwindToClassroom(sender: UIStoryboardSegue) {
        //save changes
        //if let sourceViewController = sender.source as? NewClassViewController, let newClass = sourceViewController.newClass
        if sender.identifier == "saveNewAssignmentSegue" {
            if let newAssignmentView = sender.source as? CreateAssignmentViewController {
                classroom?.setStudents(array: newAssignmentView.students)
                studentTableView.reloadData()
                self.updateClassAverageStack()
            }
        }
        print("unwinding from creating an assignment")
        //and save
        
    }
    
    //UITableViewDataSource functions
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:studentAveragesCell = tableView.dequeueReusableCell(withIdentifier: "StudentWithAverage") as! studentAveragesCell
        
        cell.studentNameField.text = "\((classroom?.students[indexPath.last!].name)!)"
        if cell.averagesStack.subviews.count == 0 {
            cell.populateAveragesStack(with: (classroom?.students[indexPath.last!])!)
        } else {
            cell.updateAveragesStack(with: (classroom?.students[indexPath.last!])!)
        }
        return cell

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (classroom?.students.count)!
    }

}
