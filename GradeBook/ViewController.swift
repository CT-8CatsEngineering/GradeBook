//
//  ViewController.swift
//  GradeBook
//
//  Created by Colin Taylor on 3/3/17.
//  Copyright © 2017 Colin Taylor. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var classesTable: UITableView!
    var classes = [Classroom]()
    var subjects = [Subject]()
    var lastStudentID:Int = 0
    var classFiles = [String]()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        subjects = self.defaultSubjects()
        checkLoadedClassroomFiles()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func defaultSubjects()->[Subject] {
        
        var defaultSubjects = [Subject]()
        
        let reading = Subject.init(name: "Reading", abr: "R", gradeScale: 100)
        defaultSubjects.append(reading)
        let writing = Subject.init(name: "Writing", abr: "Wr", gradeScale: 100)
        defaultSubjects.append(writing)
        let math = Subject.init(name: "Math", abr: "M", gradeScale: 100)
        defaultSubjects.append(math)
        let science = Subject.init(name: "Science", abr: "Sci", gradeScale: 100)
        defaultSubjects.append(science)
        let socialStudies = Subject.init(name: "Social Studies", abr: "SS", gradeScale: 100)
        defaultSubjects.append(socialStudies)
        let wordStudies = Subject.init(name: "Word Studies", abr: "WS", gradeScale: 100)
        defaultSubjects.append(wordStudies)
        
        return defaultSubjects
    }
    func loadClassRoomFromFile(path:String) -> Classroom {
        let classroom = NSKeyedUnarchiver.unarchiveObject(withFile: path)
        
        if classroom == nil {
            fatalError("failed to unarchive the file into a classroom")
        }
        
        return classroom as! Classroom
    }

    func checkLoadedClassroomFiles() {
        let saveFile:URL =  appDelegate.classroomSaveFilePath()
        let fileManager = FileManager.default
        do {
            let files = try fileManager.contentsOfDirectory(atPath: saveFile.path)
            for path in files{
                let filePath = saveFile.appendingPathComponent(path)
                if !classFiles.contains(filePath.path) {
                    let newClass = loadClassRoomFromFile(path: filePath.path)
                    if classes.contains(newClass) { //somehow the class is in the list but the file path is not. update the file path array
                        classFiles.append(filePath.path)
                    } else { //this is a new class file, load the data and add the class and path to the arrays.
                        classes.append(newClass)
                        classFiles.append(filePath.path)
                    }
                }
            }
            reloadTableContents()

        } catch {
            print("failed to get the contents of the classroom Directory")
        }
    }
    func deleteClassroom(atIndex:Int) {
        let tmpClass = classes[atIndex]
        classes.remove(at: atIndex)
        var saveFile:URL =  appDelegate.classroomSaveFilePath()
        saveFile.appendPathComponent(tmpClass.className)
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: saveFile.path) {
            do {
                try fileManager.removeItem(at: saveFile)
            } catch {
                print("failed to remove the classroom file")
            }
}
    }
    func reloadTableContents() {
        classesTable.reloadData()
    }
    
    //MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        
        if (segue.identifier == "classroomSegue") {
            let navControl = segue.destination as? UINavigationController
            guard let classroom = navControl?.topViewController as? ClassroomViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            guard let classCell = sender as? ClassTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            classroom.classroom = classCell.classObject
        }
        
        
    }
    @IBAction func unwindToClassList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? NewClassViewController, let newClass = sourceViewController.newClass {
            //save changes
            print("unwinding from creating a class")
            self.classes.append(newClass)
            classesTable.reloadData()
            //and save
            
        }
    }
    
    //UITableViewDataSource functions
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ClassTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ClassTableCell") as! ClassTableViewCell
        
        cell.ClassNameView.text = classes[indexPath.last!].className
        cell.StudentNumber.text = "\(classes[indexPath.last!].students.count) Students"
        cell.classObject = classes[indexPath.last!]
        
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return classes.count
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            self.deleteClassroom(atIndex: indexPath.last!)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
            //CT Not going to currently be used.
        }
    }
}

