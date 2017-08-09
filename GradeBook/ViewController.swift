//
//  ViewController.swift
//  GradeBook
//
//  Created by Colin Taylor on 3/3/17.
//  Copyright © 2017 Colin Taylor. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var classesTable: UITableView!
    var classes = [ClassroomMO]()
    var subjects = [SubjectTemplateMO]()
    var lastStudentID:Int = 0
    var classFiles = [String]()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loadFromCoreData()
        if subjects.count == 0 {
            subjects = self.defaultSubjects()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loadFromCoreData() {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        //2
        let classfetchRequest =
            NSFetchRequest<ClassroomMO>(entityName: "ClassroomMO")
        let subjectTemplatefetchRequest =
            NSFetchRequest<SubjectTemplateMO>(entityName: "SubjectTemplateMO")
        
        //3
        do {
            classes = try managedContext.fetch(classfetchRequest)
        } catch let error as NSError {
            print("Could not fetch classes. \(error), \(error.userInfo)")
        }
        do {
            subjects = try managedContext.fetch(subjectTemplatefetchRequest)
        } catch let error as NSError {
            print("Could not classes fetch subjects. \(error), \(error.userInfo)")
        }

    }
    
    func defaultSubjects()->[SubjectTemplateMO] {
        
        var defaultSubjects = [SubjectTemplateMO]()
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return defaultSubjects
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let entity =
            NSEntityDescription.entity(forEntityName: "SubjectTemplateMO",
                                       in: managedContext)!
        
        let reading:SubjectTemplateMO = NSManagedObject(entity: entity,
                                     insertInto: managedContext) as! SubjectTemplateMO
        
        reading.name = "Reading"
        reading.abbreviation = "R"
        reading.gradeScale = 100

        let writing:SubjectTemplateMO = NSManagedObject(entity: entity,
                                                        insertInto: managedContext) as! SubjectTemplateMO
        
        writing.name = "Writing"
        writing.abbreviation = "Wr"
        writing.gradeScale = 100
        
        let math:SubjectTemplateMO = NSManagedObject(entity: entity,
                                                        insertInto: managedContext) as! SubjectTemplateMO
        
        math.name = "Math"
        math.abbreviation = "M"
        math.gradeScale = 100

        let science:SubjectTemplateMO = NSManagedObject(entity: entity,
                                                        insertInto: managedContext) as! SubjectTemplateMO
        
        science.name = "Science"
        science.abbreviation = "Sci"
        science.gradeScale = 100

        let socialStudies:SubjectTemplateMO = NSManagedObject(entity: entity,
                                                        insertInto: managedContext) as! SubjectTemplateMO
        
        socialStudies.name = "Social Studies"
        socialStudies.abbreviation = "SS"
        socialStudies.gradeScale = 100

        let wordStudies:SubjectTemplateMO = NSManagedObject(entity: entity,
                                                        insertInto: managedContext) as! SubjectTemplateMO
        
        wordStudies.name = "Word Studies"
        wordStudies.abbreviation = "WS"
        wordStudies.gradeScale = 100

        do {
            try managedContext.save()
            defaultSubjects.append(reading)
            defaultSubjects.append(writing)
            defaultSubjects.append(math)
            defaultSubjects.append(science)
            defaultSubjects.append(socialStudies)
            defaultSubjects.append(wordStudies)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }

        return defaultSubjects
    }
    
    func deleteClassroom(atIndex:Int) {
        let tmpClass = classes[atIndex]
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext

        managedContext.delete(tmpClass)

        do {
            try managedContext.save()
            classes.remove(at: atIndex)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
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
        
        cell.ClassNameView.text = classes[indexPath.last!].name
        cell.StudentNumber.text = "\(classes[indexPath.last!].students?.count ?? 0) Students"
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

