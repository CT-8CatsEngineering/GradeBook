//
//  AssignmentReviewController.swift
//  GradeBook
//
//  Created by Colin on 5/9/17.
//  Copyright © 2017 Colin Taylor. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class AssignmentReviewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
 
    @IBOutlet weak var NavigationItem: UINavigationItem!
    @IBOutlet weak var assignmentTable: UITableView!
    var currentStudent:StudentMO? = nil

    var gradesBySubject:[SubjectMO: [GradeMO]]? = [SubjectMO: [GradeMO]]()
    var subjects:NSOrderedSet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NavigationItem.title = currentStudent?.name
        subjects = currentStudent?.classroom?.subjects
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let moc = appDelegate.persistentContainer.viewContext

        
        for subject in (subjects)! {
            
            
            let gradesfetchRequest = NSFetchRequest<GradeMO>(entityName: "GradeMO")
            gradesfetchRequest.predicate = NSPredicate(format: "student == %@ AND assignment.subject == %@", currentStudent!, (subject as! SubjectMO))
            
            do {
                let fetchedGrades:[GradeMO] = try moc.fetch(gradesfetchRequest)
                gradesBySubject?[(subject as! SubjectMO)] = fetchedGrades
            } catch {
                fatalError("Failed to fetch Subjects: \(error)")
            }
        }
        
        
        
        
        assignmentTable.reloadData()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "StudentAssignmentSegue" {
            print("going to the assignment's grade review panel")
            let navControl = segue.destination as? UINavigationController
            //let assignmentController = segue.destination as! CreateAssignmentViewController
            guard let assignmentViewController = navControl?.topViewController as? AssignmentGradesViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            let tableSelectionIndex:IndexPath = (assignmentTable.indexPathForSelectedRow)!
            
            let sectionSubject:SubjectMO = subjects?[tableSelectionIndex.first!] as! SubjectMO

            assignmentViewController.currentAssignment = (gradesBySubject?[sectionSubject]?[tableSelectionIndex.last!])?.assignment
        } else {
            print("neither the assignment button nor the student detail was pressed, going back to the list of classes")
        }
    }

    //UITableViewDataSource functions
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ReviewAssignmentCell = tableView.dequeueReusableCell(withIdentifier: "AssignmentReviewCell") as! ReviewAssignmentCell
        
        let sectionSubject:SubjectMO = subjects?[indexPath.first!] as! SubjectMO

        let subjectGrades:[GradeMO] = gradesBySubject![sectionSubject]!
        let grade:GradeMO = subjectGrades[indexPath.last!]
        
        cell.AssignmentName.text = grade.assignment?.name
        cell.GradeLabel.text = "\(grade.score)/\(grade.assignment?.totalPoints ?? 100)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionSubject:SubjectMO = subjects?[section] as! SubjectMO
        return gradesBySubject![sectionSubject]!.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return subjects!.count
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        var sectionNames = [String]()
        for subject in (subjects)! {
            sectionNames.append((subject as! SubjectMO).name!)
        }
        return sectionNames
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return (subjects?[section] as! SubjectMO).name
    }
    //UITableViewDelegate functions
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
