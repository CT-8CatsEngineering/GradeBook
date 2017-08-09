//
//  SubjectPickerView.swift
//  GradeBook
//
//  Created by Colin on 8/9/17.
//  Copyright © 2017 Colin Taylor. All rights reserved.
//

import Foundation
import UIKit

class SubjectPickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var subjectPicker: UIPickerView!
    
    var classSubjects:[SubjectMO] = [SubjectMO]()
    var selectedSubject:SubjectMO? = nil

    var selectedSubjectAction: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func dismissUserDetail(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    //UIPickerViewDelegate functions
    //not really a delegate function but it is a picker utility
    func selectedSubjectOnPickerView() -> SubjectMO {
        return classSubjects[subjectPicker.selectedRow(inComponent: 0)]
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        return classSubjects[row].name
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedSubject = classSubjects[subjectPicker.selectedRow(inComponent: 0)]
        self.dismiss(animated: true, completion: selectedSubjectAction)
    }
    //UIPickerViewDataSource functions
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return classSubjects.count
    }

}
