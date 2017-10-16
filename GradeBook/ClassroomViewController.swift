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
    var classroom:ClassroomMO?
    var lastAssignmentID:Int = 0
    
    var tappedSubject:SubjectMO?
    
    @IBOutlet weak var studentTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if (classroom != nil) {
            //print("classroom is not nil \(String(describing: classroom?.className))")
            self.setUpClassAverageStack()
        }
        //print("class average stack views \(classAveragesStack.arrangedSubviews)")
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
            newAssignmentController.students = (classroom?.students)!.array as! [StudentMO]
            newAssignmentController.classSubjects = (classroom?.subjects)!.array as! [SubjectMO]
                        
        }else if segue.identifier == "viewStudentDetailsSegue" {
            print("going to the student details panel")
            let navControl = segue.destination as? UINavigationController
            //let newAssignmentController = segue.destination as! CreateAssignmentViewController
            guard let reviewAssignmentController = navControl?.topViewController as? AssignmentReviewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            let indexPath = studentTableView.indexPathForSelectedRow
            let currentStudent:StudentMO = (classroom?.students![(indexPath?.last!)!])! as! StudentMO
            reviewAssignmentController.currentStudent = currentStudent

        } else if segue.identifier == "subjectAssignmentsSegue" {
            print("going to the subject assignments panel")
            /*let navControl = segue.destination as? UINavigationController
            //let newAssignmentController = segue.destination as! CreateAssignmentViewController
            guard let subjectVC = navControl?.topViewController as? SubjectAssignmentReviewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }*/
            

        }else {
            print("neither the assignment button nor the student detail was pressed, going back to the list of classes")
        }
        
    }
    
    func openSubjectDetails(sender:UITapGestureRecognizer) {
        //print("stackview accessibility name: \((sender.view as! SubjectStackView).subject)")
        let mystoryboard:UIStoryboard = UIStoryboard.init(name:"Main", bundle: nil)
        let navControl:UINavigationController = mystoryboard.instantiateViewController(withIdentifier: "SubjectAssignmentView") as! UINavigationController
        let subjectVC:SubjectAssignmentReviewController = navControl.topViewController as! SubjectAssignmentReviewController
        
        subjectVC.currentSubject = (sender.view as! SubjectStackView).subject
        
        //performSegue(withIdentifier: "SubjectAssignmentView", sender: self)
        self.navigationController?.pushViewController(subjectVC, animated: true)
    }
    
    func setUpClassAverageStack() {
        let x = 0
        let height:Int = Int(classAveragesStack.frame.height)
        let count:CGFloat = CGFloat((classroom?.subjects!.count)!)
        let width:Int = Int(classAveragesStack.frame.width/count)
        
        for (subject, score) in (classroom?.calculateWholeClassAverages())! {
            
            let frame = CGRect(x: x, y: 0, width: width, height: height)
            let subjectView:SubjectStackView = SubjectStackView.init(frame: frame)
            subjectView.subject = subject
            subjectView.accessibilityIdentifier = "\(subject.name ?? "")"
            subjectView.axis = UILayoutConstraintAxis.vertical
            subjectView.backgroundColor = UIColor.lightGray
            
            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.openSubjectDetails(sender:)))
            subjectView.isUserInteractionEnabled = true
            subjectView.addGestureRecognizer(tap)
            
            let abreviationLabel = UILabel.init()
            abreviationLabel.accessibilityIdentifier = "abreviationLabel"
            abreviationLabel.text = subject.abbreviation
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
        let classAverages = (classroom?.calculateWholeClassAverages())!
        
        let averagesSubviews = classAveragesStack.subviews
        
        for view in averagesSubviews {
            var subject:SubjectMO? = nil
            for (testSubject, _) in classAverages {
                if testSubject.name == view.accessibilityIdentifier! {
                    subject = testSubject
                }
            }
            
            if subject != nil { //if we found a matching subject we can update the view.
                let labelSubviews = view.subviews
                for subview in labelSubviews {
                    let labelSubview = subview as! UILabel
                    if labelSubview.accessibilityIdentifier == "averageLabel" {
                        var averageGradeString:String = "\(classAverages[subject!] ?? 0)"
                        if averageGradeString == "0" {
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
        
    }
    @IBAction func unwindFromAssignmentDetails(sender: UIStoryboardSegue) {
        //if let sourceViewController = sender.source as? NewClassViewController, let newClass = sourceViewController.newClass
        if sender.identifier == "saveNewAssignmentSegue" {
            self.updateClassAverageStack()
            studentTableView.reloadData()
        }
        
    }
   
    //UITableViewDataSource functions
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:studentAveragesCell = tableView.dequeueReusableCell(withIdentifier: "StudentWithAverage") as! studentAveragesCell
        
        cell.studentNameField.text = "\(((classroom?.students?[indexPath.last!] as! StudentMO).name)!)"
        if cell.averagesStack.subviews.count == 0 {
            cell.populateAveragesStack(with: (classroom?.students![indexPath.last!])! as! StudentMO)
        } else {
            cell.updateAveragesStack(with: (classroom?.students![indexPath.last!])! as! StudentMO)
        }
        return cell

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (classroom?.students!.count)!
    }

}
