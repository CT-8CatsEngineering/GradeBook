//
//  NewClassViewController.swift
//  GradeBook
//
//  Created by Colin Taylor on 3/27/17.
//  Copyright © 2017 Colin Taylor. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class NewClassViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var studentListView: UITableView!
    @IBOutlet weak var classNameField: UITextField!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var saveButton: UIBarButtonItem!
    var selectedSubjects:NSMutableOrderedSet = NSMutableOrderedSet.init()
    var parentView: ViewController?
    var students = [String]()
    var newClass:ClassroomMO?
    
    var selectedFileURL:URL = URL.init(string: "/")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let uiController = self.presentingViewController?.childViewControllers[0]
        parentView = (uiController as! ViewController)
        //loadFileNames()
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
    }
        
    @IBAction func importFromFile(_ sender: Any) {
        let storyboard = UIStoryboard(name:"Main", bundle:nil)
        let filePickerVC = storyboard.instantiateViewController(withIdentifier: "FileImportSelectionView") as! ImportFilePickerViewController
        
        filePickerVC.loadFileNames()
        
        filePickerVC.selectedFileImportAction = {()
            print("dismissing the subject picker view")
            self.selectedFileURL = filePickerVC.selectedFileURL
            self.loadStudentsFromFile()
            self.studentListView.reloadData()
        }
        
        filePickerVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.present(filePickerVC, animated: true, completion: {()
            print("present subject picker complete")
        })

        //self.loadStudentsFromFile()
        //studentListView.reloadData()
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
        
        //this may be backwards need to look more closely when I finish the core data conversion.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            
            guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
                    return
            }
            
            let managedContext =
                appDelegate.persistentContainer.viewContext
            
            let entity = NSEntityDescription.entity(forEntityName: "ClassroomMO", in: managedContext)!
            
            self.newClass = NSManagedObject(entity: entity, insertInto: managedContext) as? ClassroomMO

            self.newClass?.name = classNameField.text
            let studentObj:[StudentMO] = loadStudents()
            
            self.newClass!.subjects = self.createSubjectsFromSelectedTemplates()
            self.newClass!.students = NSOrderedSet.init(array: studentObj)

            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
                managedContext.rollback()
            }

            
            return
        }
        
       
        
    }
    func createSubjectsFromSelectedTemplates() ->NSOrderedSet {
        var subjects = [SubjectMO]()
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return NSOrderedSet.init()
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "SubjectMO", in: managedContext)!
        

        
        for subjectTemplate in selectedSubjects {
            let newSubject:SubjectMO = NSManagedObject(entity: entity, insertInto: managedContext) as! SubjectMO
            
            newSubject.name = (subjectTemplate as! SubjectTemplateMO).name
            newSubject.abbreviation = (subjectTemplate as! SubjectTemplateMO).abbreviation
            newSubject.gradeScale = (subjectTemplate as! SubjectTemplateMO).gradeScale
            newSubject.classroom = self.newClass
            
            subjects.append(newSubject)
        }
        
        return NSOrderedSet.init(array: subjects)
    }
    
    //so that we can actually update the data in the array of student names when they are edited.
    func updateStudentName(inName:String, position:Int){
        students[position]=inName
    }
    
    func loadStudentsFromFile() {
        do {
            var studentLines:[String] = [String]()
            if selectedFileURL.pathExtension == "txt"  {
                let fileString:String = try String.init(contentsOf: selectedFileURL)
                
                studentLines = self.parseStudentList(inputString: fileString)
                
            } else if selectedFileURL.pathExtension == "rtf"{
                let fileData = try Data.init(contentsOf: selectedFileURL)
                let fileString:String = try NSAttributedString.init(data:fileData, documentAttributes:nil).string
                
                studentLines = self.parseStudentList(inputString: fileString)
            }
            
            for studentName in studentLines {
                students.append(studentName)
            }
            
        }
        catch {
            print("error reading from file")
        }
        
    }
    
    func parseStudentList(inputString:String)->[String] {
        //If necessary put more logic for determining comma/newline separators in this function.
        //one possiblity is to limit the length of the components and if they exceed that try the other separator. May also help eliminate incorrect files.
        var studentLines:[String] = [String]()
        if inputString.contains(",") {
            studentLines = inputString.components(separatedBy: ",")
        } else {
            studentLines = inputString.components(separatedBy: "\n")
        }
        return studentLines
    }
    
    func loadStudents()->[StudentMO] {
        var studentObjects = [StudentMO]()
        
        for nameString in students {
            parentView?.lastStudentID += 1
            
            guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
                    return studentObjects
            }
            
            let managedContext =
                appDelegate.persistentContainer.viewContext
            
            let entity =
                NSEntityDescription.entity(forEntityName: "StudentMO",
                                           in: managedContext)!
            
            let newStudent:StudentMO = NSManagedObject(entity: entity,
                                                            insertInto: managedContext) as! StudentMO
            
            newStudent.name = nameString
            newStudent.id = "\((parentView?.lastStudentID)!)"
            newStudent.classroom = self.newClass         //setValue(self.newClass, forKey: "classroom")
            //let newStudent = Student.init(name: nameString, inID: (parentView?.lastStudentID)!)
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
        cell.SubjectScale.text = "\(parentView!.subjects[indexPath.last!].gradeScale)"
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
            selectedSubjects.remove(cell.subjectObject!)
            cell.setSelected(inBool: false)
        } else {
            selectedSubjects.add(cell.subjectObject!)
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
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2//first section contains a cell for creating new students. Second section contains the actual list for of students
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.first == 1 {
            let cell:StudentListCell = tableView.dequeueReusableCell(withIdentifier: "StudentCell") as! StudentListCell
            
            cell.studentNameField.text = students[indexPath.last!]
            cell.controller = self
            cell.position = indexPath.last!
            
            return cell
        } else {
            let cell:NewStudentCell = tableView.dequeueReusableCell(withIdentifier: "NewStudentCell") as! NewStudentCell
            cell.controller = self
            
            return cell
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return students.count
        } else {
            return 1
        }
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        // allows deletion of students
        if indexPath.first == 1 {
            if students.count > 1 {
                students.remove(at: indexPath.last!)
                tableView.reloadData()
            } else {
                self.clearClassList(self)
            }
        } else {
            
        }
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.first == 1 {
            return true
        } else {
            return false
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.first == 0 {
            return CGFloat(72)
        } else {
            return CGFloat(42)
        }
    }
}
