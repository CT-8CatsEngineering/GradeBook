//
//  AssignmentReviewController.swift
//  GradeBook
//
//  Created by Colin on 5/9/17.
//  Copyright © 2017 Colin Taylor. All rights reserved.
//

import Foundation
import UIKit

class AssignmentReviewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
 
    @IBOutlet weak var NavigationItem: UINavigationItem!
    @IBOutlet weak var assignmentTable: UITableView!
    var currentStudent:Student? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        NavigationItem.title = currentStudent?.name
        assignmentTable.reloadData()
        
    }
    //UITableViewDataSource functions
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ReviewAssignmentCell = tableView.dequeueReusableCell(withIdentifier: "AssignmentReviewCell") as! ReviewAssignmentCell
        let subject = currentStudent?.subjectsArray[indexPath.first!]
        let assignment:Assignment = (subject?.assignments[indexPath.last!])!
        
        cell.AssignmentName.text = assignment.title
        cell.GradeLabel.text = "\(assignment.grade)/\(assignment.totalPoints)"
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (currentStudent?.subjectsArray[section].assignments.count)! // return the number of assignments for the subject
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return (currentStudent?.subjectsArray.count)! // return the number of subjects for the student
    }
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        var sectionNames = [String]()
        for subject in (currentStudent?.subjectsArray)! {
            sectionNames.append(subject.name)
        }
        return sectionNames
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return currentStudent?.subjectsArray[section].name
    }
    //UITableViewDelegate functions
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
