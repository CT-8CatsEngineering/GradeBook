//
//  CreateAssignmentViewController.swift
//  GradeBook
//
//  Created by Colin on 4/13/17.
//  Copyright © 2017 Colin Taylor. All rights reserved.
//

import Foundation
import UIKit

class CreateAssignmentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    var classSubjects = [Subject]()
    var students = [Student]()//each item is copied and should be separate from the actual list in the classroom
    var studentScores = [String: Int]()
    var selectedSubject:Subject? = nil
    
    @IBOutlet weak var subjectPicker: UIPickerView!
    @IBOutlet weak var assignmentName: UITextField!
    @IBOutlet weak var assignmentTotalPoints: UITextField!
    @IBOutlet weak var studentTable: UITableView!
    @IBOutlet weak var gradesView: UIView!
    @IBOutlet weak var subjectSelectionView: UIView!
    @IBOutlet weak var SubjectDisplay: UITextField!
    
    var currentTextField:UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gradesView.isHidden = true
        selectedSubject = self.selectedSubjectOnPickerView()
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.view.endEditing(false)
        super.viewWillDisappear(animated)
    }
    @IBAction func beginGradeChange(_ sender: Any) {
        currentTextField = (sender as! UITextField)
    }
    @IBAction func editGrades(_ sender: Any) {
        subjectSelectionView.isHidden = true
        gradesView.isHidden = false
        assignmentName.isEnabled = false
        assignmentTotalPoints.isEnabled = false
        SubjectDisplay.text = selectedSubjectOnPickerView().name
        SubjectDisplay.isEnabled = false
        
        studentTable.reloadData()
    }
    @IBAction func assignGrade(_ sender: Any) {
        let textField = sender as! UITextField
        let currentAssignmentCell:StudentAssignmentCell = textField.superview?.superview as! StudentAssignmentCell
        let currentStudent:Student  = currentAssignmentCell.studentObj!
        
        let studentSubject = currentStudent.subjects[(selectedSubject?.name)!]
        let newAssignment = Assignment.init(title: assignmentName.text!, grade: Int(currentAssignmentCell.gradeField.text!)!, totalPoints: Int(assignmentTotalPoints.text!)!)
        studentSubject?.addAssingment(newAssignment: newAssignment)
        
        currentTextField = nil
    }
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else if let owningNavigationController = navigationController {
            owningNavigationController.popViewController(animated: true)
        } else {
            fatalError("the mealViewController is not inside a navigation Controller")
        }
    }
    //UITableViewDataSource functions
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:StudentAssignmentCell = tableView.dequeueReusableCell(withIdentifier: "StudentScoreCell") as! StudentAssignmentCell
        
        cell.assignmentStudentName.text = students[indexPath.last!].name
        cell.studentObj = students[indexPath.last!]
        cell.totalPoints.text = "/\(assignmentTotalPoints.text ?? "total")"
        
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }
    //UITableViewDelegate functions
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    //UIPickerViewDelegate functions
    //not really a delegate function but it is a picker utility
    func selectedSubjectOnPickerView() -> Subject {
        return classSubjects[subjectPicker.selectedRow(inComponent: 0)]
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        return classSubjects[row].name
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedSubject = classSubjects[subjectPicker.selectedRow(inComponent: 0)]
    }
    //UIPickerViewDataSource functions
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return classSubjects.count
    }
    
}
