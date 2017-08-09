//
//  CreateAssignmentViewController.swift
//  GradeBook
//
//  Created by Colin on 4/13/17.
//  Copyright © 2017 Colin Taylor. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CreateAssignmentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate/*, UIPickerViewDelegate, UIPickerViewDataSource*/ {

    var classSubjects = [SubjectMO]()
    var students = [StudentMO]()
    var studentScores = [String: Int]()
    var selectedSubject:SubjectMO? = nil
    var newAssignment:AssignmentMO? = nil
    
    var moc:NSManagedObjectContext? = nil
    
    //@IBOutlet weak var subjectPicker: UIPickerView!
    @IBOutlet weak var assignmentName: UITextField!
    @IBOutlet weak var assignmentTotalPoints: UITextField!
    @IBOutlet weak var studentTable: UITableView!
    @IBOutlet weak var gradesView: UIView!
    @IBOutlet weak var subjectSelectionView: UIView!
    @IBOutlet weak var SubjectDisplay: UITextField!
    @IBOutlet weak var ActiveSwitch: UISwitch!
    
    var currentTextField:UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //gradesView.isHidden = true
        //gradesView.isUserInteractionEnabled = false
        //selectedSubject = self.selectedSubjectOnPickerView()
        studentTable.reloadData()
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        moc = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "AssignmentMO", in: moc!)!
        
        newAssignment = NSManagedObject(entity: entity, insertInto: moc!) as? AssignmentMO
        


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
        //gradesView.isHidden = false
        //gradesView.isUserInteractionEnabled = true
        assignmentName.isEnabled = false
        assignmentTotalPoints.isEnabled = false
        //SubjectDisplay.text = selectedSubjectOnPickerView().name
        SubjectDisplay.isEnabled = false
        
        let entity = NSEntityDescription.entity(forEntityName: "AssignmentMO", in: moc!)!

        newAssignment = NSManagedObject(entity: entity, insertInto: moc!) as? AssignmentMO
        
        newAssignment?.name = assignmentName.text
        newAssignment?.status = ActiveSwitch.isOn
        newAssignment?.totalPoints = Int64(assignmentTotalPoints.text!)!
        newAssignment?.subject = selectedSubject
        
        selectedSubject?.addToAssignments(newAssignment!)
        
        studentTable.reloadData()
    }
    
    @IBAction func selectSubject(_ sender:Any) {
        let storyboard = UIStoryboard(name:"Main", bundle:nil)
        let subjectPickerVC = storyboard.instantiateViewController(withIdentifier: "SubjectPickerView") as! SubjectPickerViewController
        
        subjectPickerVC.classSubjects = classSubjects
        
        subjectPickerVC.selectedSubjectAction = {()
                print("dismissing the subject picker view")
                self.selectedSubject = subjectPickerVC.selectedSubject
                self.SubjectDisplay.text = self.selectedSubject?.name
                self.SubjectDisplay.endEditing(true)
            }
        
        subjectPickerVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.present(subjectPickerVC, animated: true, completion: {()
            print("present subject picker complete")
        })

    }
    
    @IBAction func assignGrade(_ sender: Any) {
        let textField = sender as! UITextField
        let currentAssignmentCell:StudentAssignmentCell = textField.superview?.superview as! StudentAssignmentCell
        let currentStudent:StudentMO  = currentAssignmentCell.studentObj!
        
        let entity = NSEntityDescription.entity(forEntityName: "GradeMO", in: moc!)!
        
        let grade:GradeMO = NSManagedObject(entity: entity, insertInto: moc!) as! GradeMO
        grade.assignment = newAssignment
        grade.student = currentStudent
        grade.score = Float(currentAssignmentCell.gradeField.text!)!
        
        currentStudent.addToGrades(grade)
        
        currentTextField = nil
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        newAssignment?.name = assignmentName.text
        newAssignment?.status = ActiveSwitch.isOn
        newAssignment?.totalPoints = Int64(assignmentTotalPoints.text!)!
        newAssignment?.subject = selectedSubject

        do {
            try moc?.save()
        } catch let error as NSError {
            print("Could not save after closing assignment view. \(error), \(error.userInfo)")
        }
 
    }
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        //undo changes since we canceled.
        moc?.rollback()
        
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
/*    func selectedSubjectOnPickerView() -> SubjectMO {
        return classSubjects[subjectPicker.selectedRow(inComponent: 0)]
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        return classSubjects[row].name
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedSubject = classSubjects[subjectPicker.selectedRow(inComponent: 0)]
        SubjectDisplay.text = selectedSubject?.name
    }
    //UIPickerViewDataSource functions
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return classSubjects.count
    }*/
    
}
