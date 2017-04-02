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

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        subjects = self.defaultSubjects()
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
    @IBAction func unwindToClassList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? NewClassViewController, let newClass = sourceViewController.newClass {
            //save changes
            print("unwinding from creating a class")
            self.classes.append(newClass)
            classesTable.reloadData()
            //and save
            
        }
    }

    func reloadTableContents() {
        classesTable.reloadData()
    }
    
    //UITableViewDataSource functions
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ClassTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ClassTableCell") as! ClassTableViewCell
        
        cell.ClassNameView.text = classes[indexPath.last!].className
        cell.StudentNumber.text = "\(classes[indexPath.last!].students.count) Students"
        
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return classes.count
    }
    
}

