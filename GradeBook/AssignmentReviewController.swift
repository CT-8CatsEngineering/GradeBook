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
