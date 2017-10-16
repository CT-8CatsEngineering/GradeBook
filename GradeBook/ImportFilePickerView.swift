//
//  ImportFilePickerViewController.swift
//  GradeBook
//
//  Created by Colin on 8/9/17.
//  Copyright © 2017 Colin Taylor. All rights reserved.
//

import Foundation
import UIKit

class ImportFilePickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var filePicker: UIPickerView!
    var filenames:[URL] = [URL]()
    var selectedFileURL:URL = URL.init(string: "/")!
    var selectedFileImportAction: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func loadFileNames() {
        //also look into implementing UIDocumentPickerViewController later and UIDocumentInteractionController
        let fileManager = FileManager.default
        let dirs = fileManager.urls(for: .documentDirectory, in: .userDomainMask).last
        var filename:URL = dirs!
        filename.appendPathComponent("StudentLists")
        //test file information
        let studentListDirectory = filename
//        let nameString = "Joe Smith,Ann Lin,Zack Smith,Beth Lin,Laura Smith,Larry Lin,Ben Smith,Mary Lin"
//        let nameString2 = "Bob Dylan,Jeff Morrison,Zack Taylor,Kelsey Gram,Lindsey Lohan,Kattie Perry"
        do {
            if !fileManager.fileExists(atPath: filename.absoluteString) {
                try fileManager.createDirectory(at: filename, withIntermediateDirectories: true, attributes: nil)
            }
            //let testXmlURL = filename.appendingPathComponent("sampleClasslist.xlsx")
            let RTFReturnFileURL:URL = filename.appendingPathComponent("RTFReturnSeparated.rtf")
            let RTFCommaFileURL:URL = filename.appendingPathComponent("RTFCommaSep.rtf")
            let TXTReturnFileURL:URL = filename.appendingPathComponent("txtReturnSeparated.txt")
            let TXTCommaFileURL:URL = filename.appendingPathComponent("txtCommaSep.txt")
            
            if !fileManager.fileExists(atPath: RTFReturnFileURL.absoluteString) {
                let filePath:URL = Bundle.main.url(forResource: "RTFReturnSeparated", withExtension: "rtf")!
                try fileManager.copyItem(at: filePath, to: RTFReturnFileURL)
            }
            if !fileManager.fileExists(atPath: RTFCommaFileURL.absoluteString) {
                let filePath:URL = Bundle.main.url(forResource: "RTFCommaSep", withExtension: "rtf")!
                try fileManager.copyItem(at: filePath, to: RTFCommaFileURL)
            }
            if !fileManager.fileExists(atPath: TXTReturnFileURL.absoluteString) {
                let filePath:URL = Bundle.main.url(forResource: "txtReturnSeparated", withExtension: "txt")!
                try fileManager.copyItem(at: filePath, to: TXTReturnFileURL)
            }
            if !fileManager.fileExists(atPath: TXTCommaFileURL.absoluteString) {
                let filePath = Bundle.main.url(forResource: "txtCommaSep", withExtension: "txt")!
                try fileManager.copyItem(at: filePath, to: TXTCommaFileURL)
            }
            /*let test2:Bool = try testXmlURL.checkResourceIsReachable()
            if !test2 {
                let filePath = Bundle.main.url(forResource: "sampleClasslist", withExtension: "xlsx")
                try fileManager.copyItem(at: filePath!, to: testXmlURL)
            }*/
        } catch {
            print("failed to write to file or get contents")
        }
        //end test file code
        let dirsPath = (studentListDirectory.path)
        let contents = fileManager.subpaths(atPath:dirsPath )
        
        for pathString in contents! {
            if pathString.hasSuffix("txt") || pathString.hasSuffix("rtf") {
                
                filenames.append(studentListDirectory.appendingPathComponent(pathString))
            }
        }

    }
    
    @IBAction func dismissUserDetail(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func importSelectedFile(_ sender: Any) {
        self.dismiss(animated: true, completion: selectedFileImportAction)
    }
    @IBAction func helpDisclosure(_ sender: Any) {
    }

    //UIPickerViewDelegate functions
    //not really a delegate function but it is a picker utility
    func selectedSubjectOnPickerView() -> String {
        return filenames[filePicker.selectedRow(inComponent: 0)].absoluteString
    }
    //UIPickerViewDelegate functions
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        return filenames[row].lastPathComponent
    }
    //UIPickerViewDataSource functions
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return filenames.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedFileURL = filenames[filePicker.selectedRow(inComponent: 0)]
    }
    //UIPickerViewDataSource functions
    //    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
    //        return filenames[row]
    //    }
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 1
//    }
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return filenames.count
//    }

}
