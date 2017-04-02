//
//  NewClassViewController.swift
//  GradeBook
//
//  Created by Colin Taylor on 3/27/17.
//  Copyright © 2017 Colin Taylor. All rights reserved.
//

import Foundation
import UIKit

class NewClassViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDataSource  {
    @IBOutlet weak var studentListView: UITableView!
    @IBOutlet weak var classNameField: UITextField!
    @IBOutlet weak var filePicker: UIPickerView!
    @IBOutlet weak var classListView: UIView!
    @IBOutlet weak var ImportView: UIView!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var saveButton: UIBarButtonItem!
    var selectedSubjects = [Subject]()
    var parentView: ViewController?
    var students = [String]()
    var newClass:Classroom?
    var filenames = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let uiController = self.presentingViewController?.childViewControllers[0]
        parentView = (uiController as! ViewController)
        classListView.isHidden = true
        loadFileNames()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func clearClassList(_ sender: Any) {
        students.removeAll()
        studentListView.reloadData()
        classListView.isHidden = true
        ImportView.isHidden = false
    }
    
    @IBAction func helpDisclosure(_ sender: Any) {
    }
    
    @IBAction func loadSelectedFile(_ sender: Any) {
        self.loadStudentsFromFile()
        ImportView.isHidden = true
        studentListView.reloadData()
        classListView.isHidden = false
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        print("cancel clicked")
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else if let owningNavigationController = navigationController {
            owningNavigationController.popViewController(animated: true)
        } else {
            fatalError("the mealViewController is not inside a navigation Controller")
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("preparing for segue")
        super.prepare(for: segue, sender: sender)
        
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            self.newClass = Classroom.init(name: classNameField.text!)
            
            let studentObj = loadStudents(inClassroom: self.newClass!)
            
            self.newClass!.setSubjects(array: selectedSubjects)
            self.newClass!.setStudents(array: studentObj)
            
            return
        }
        
       
        
    }
    //so that we can actually update the data in the array of student names when they are edited.
    func updateStudentName(inName:String, position:Int){
        students[position]=inName
    }
    func loadFileNames() {
        //also look into implementing UIDocumentPickerViewController later
        let fileManager = FileManager.default
        let dirs = fileManager.urls(for: .documentDirectory, in: .userDomainMask).last
        var filename = dirs
        let string = "Joe Smith,Ann Lin,Zack Smith,Beth Lin,Laura Smith,Larry Lin,Ben Smith,Mary Lin"
        do {
            filename?.appendPathComponent("testFile.rtf")
            if !fileManager.fileExists(atPath: (filename?.absoluteString)!) {
                try string.write(to: filename!, atomically: false, encoding: String.Encoding.utf8)
            }
            let dirsPath = (dirs?.path)!
            let contents = try fileManager.subpaths(atPath:dirsPath )

            print("starting path \(dirs)")
            print("contents of dir: \(contents)")
        } catch {
            print("failed to write to file or get contents")
        }
        
        
        
    }
    
    func loadStudentsFromFile() {
        
        //temp testing students array.
        students.append("Joe Smith")
        students.append("Ann Lin")
        students.append("Zack Smith")
        students.append("Beth Lin")
        students.append("Laura Smith")
        students.append("Larry Lin")
        students.append("Ben Smith")
        students.append("Mary Lin")
        
    }
    func loadStudents(inClassroom:Classroom)->[Student] {
        var studentObjects = [Student]()
        
        for nameString in students {
            parentView?.lastStudentID += 1
            let newStudent = Student.init(name: nameString, inID: (parentView?.lastStudentID)!, inClass: inClassroom)
            newStudent.setSubjects(inSubjectArray: selectedSubjects)
            studentObjects.append(newStudent)
        }
        return studentObjects
    }
    
    //MARK: UICollectionDataSource functions
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return parentView!.subjects.count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1//I think I only want 1 section
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:subjectCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ClassCreationSubject", for: indexPath) as! subjectCell

        cell.SubjectName.text = parentView!.subjects[indexPath.last!].name
        cell.SubjectScale.text = "\(parentView!.subjects[indexPath.last!].gradingScale)"
        cell.subjectObject = parentView!.subjects[indexPath.last!]
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return false//I do not want to allow items to be moved around.
    }
    //MARK: UICollectionViewDelegate functions
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell:subjectCell = collectionView.cellForItem(at: indexPath) as! subjectCell
        
        if (selectedSubjects.contains(cell.subjectObject!)) {
            let subjectIndex:Int = selectedSubjects.index(of: cell.subjectObject!)!
            selectedSubjects.remove(at: subjectIndex)
            cell.setSelected(inBool: false)
        } else {
            selectedSubjects.append(cell.subjectObject!)
            cell.setSelected(inBool: true)
        }
        
    }
    
    //MARK: UICollectionViewDelegateFlowLayout delegate
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize.init(width: 86, height: 83)
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }

    //UITableViewDataSource functions
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:StudentListCell = tableView.dequeueReusableCell(withIdentifier: "StudentCell") as! StudentListCell
        
        cell.studentNameField.text = students[indexPath.last!]
        cell.controller = self
        cell.position = indexPath.last!
        
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        // allows deletion of students
        if students.count > 1 {
            students.remove(at: indexPath.last!)
            tableView.reloadData()
        } else {
            self.clearClassList(self)
        }
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}
