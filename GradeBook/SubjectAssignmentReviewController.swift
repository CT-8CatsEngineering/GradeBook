//
//  SubjectAssignmentReviewController.swift
//  GradeBook
//
//  Created by Colin on 8/23/17.
//  Copyright © 2017 Colin Taylor. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class SubjectAssignmentReviewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var NavigationItem: UINavigationItem!
    @IBOutlet weak var assignmentTable: UITableView!
    var currentSubject:SubjectMO? = nil
    
    var assignmentAverages:[AssignmentMO: Float]? = [AssignmentMO: Float]()
    var assignments:NSOrderedSet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NavigationItem.title = currentSubject?.name
        assignments = currentSubject?.assignments
        
        for assignment in (assignments)! {
            assignmentAverages?[(assignment as! AssignmentMO)] = (assignment as! AssignmentMO).classAverage()
        }
        
        assignmentTable.reloadData()
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "SubjectAssignmentSegue" {
            print("going to the assignment's grade review panel")
            let navControl = segue.destination as? UINavigationController
            //let assignmentController = segue.destination as! CreateAssignmentViewController
            guard let assignmentViewController = navControl?.topViewController as? AssignmentGradesViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            let tableSelectionIndex:Int = (assignmentTable.indexPathForSelectedRow?.last)!
            assignmentViewController.currentAssignment = assignments?[tableSelectionIndex] as? AssignmentMO
        } else {
            print("neither the assignment button nor the student detail was pressed, going back to the list of classes")
        }
    }
    //UITableViewDataSource functions
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:SubjectAssignmentCell = tableView.dequeueReusableCell(withIdentifier: "SubjectAssignmentCell") as! SubjectAssignmentCell
        
        let rowAssignment:AssignmentMO = assignments?[indexPath.last!] as! AssignmentMO
        
        let grade:Float = 100 * assignmentAverages![rowAssignment]!
        
        cell.AssignmentName.text = rowAssignment.name
        cell.GradeLabel.text = "\(grade)/\(currentSubject?.gradeScale ?? 100)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assignments!.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //UITableViewDelegate functions
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            //self.deleteClassroom(atIndex: indexPath.last!)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
            //CT Not going to currently be used.
        }
    }

}
