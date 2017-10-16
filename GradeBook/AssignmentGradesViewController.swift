//
//  AssignmentGradesViewController.swift
//  GradeBook
//
//  Created by Colin on 8/25/17.
//  Copyright © 2017 Colin Taylor. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class AssignmentGradesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var NavigationItem: UINavigationItem!
    @IBOutlet weak var gradesTable: UITableView!
    var currentAssignment:AssignmentMO? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NavigationItem.title = currentAssignment?.name
        
        gradesTable.reloadData()
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "backToStudentViewSegue" {
            print("going to the assignment's grade review panel")
            let navControl = segue.destination as? UINavigationController
            //let assignmentController = segue.destination as! CreateAssignmentViewController
            guard let assignmentViewController = navControl?.topViewController as? AssignmentReviewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            let tableSelectionIndex:Int = (gradesTable.indexPathForSelectedRow?.last)!
            assignmentViewController.currentStudent = (currentAssignment?.grades?[tableSelectionIndex] as! GradeMO).student
        } else if segue.identifier == "editAssignmentSegue" {
            print("going to the add assignment panel")
            let navControl = segue.destination as? UINavigationController
            //let newAssignmentController = segue.destination as! CreateAssignmentViewController
            guard let newAssignmentController = navControl?.topViewController as? CreateAssignmentViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            let classroom:ClassroomMO = (currentAssignment?.subject?.classroom)!
            newAssignmentController.students = (classroom.students)!.array as! [StudentMO]
            newAssignmentController.classSubjects = (classroom.subjects)!.array as! [SubjectMO]
            newAssignmentController.currentAssignment = self.currentAssignment
            
        } else {
            print("neither the assignment button nor the student detail was pressed, going back to the list of classes")
        }
    }
    @IBAction func unwindFromAssignmentDetails(sender: UIStoryboardSegue) {
        //save changes
        //if let sourceViewController = sender.source as? NewClassViewController, let newClass = sourceViewController.newClass
        if sender.identifier == "saveNewAssignmentSegue" {
            gradesTable.reloadData()
        }
        print("unwinding from creating an assignment")
        //and save
        
    }

    //UITableViewDataSource functions
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:AssignmentStudentCell = tableView.dequeueReusableCell(withIdentifier: "StudentGradeCell") as! AssignmentStudentCell
        
        let grade:GradeMO = currentAssignment!.grades![indexPath.last!] as! GradeMO
        
        cell.StudentName.text = grade.student?.name
        cell.GradeLabel.text = "\(grade.score)/\(currentAssignment?.totalPoints ?? 100)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentAssignment?.grades!.count ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //UITableViewDelegate functions
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
