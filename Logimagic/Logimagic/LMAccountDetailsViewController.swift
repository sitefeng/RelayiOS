//
//  LMAccountDetailsViewController.swift
//  Logimagic
//
//  Created by Si Te Feng on 9/12/15.
//  Copyright (c) 2015 Si Te Feng. All rights reserved.
//

import UIKit
import CoreData

class LMAccountDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, LMAccountDetailsCellDelegate {

    var selectedAccountType: String!
    
    @IBOutlet weak var tableView: UITableView!
    let kAccountDetailsCellId = "kAccountDetailsCellId"
    
    let textFieldNames: [String] = ["Name", "Email", "Password"]
    var textFieldDict: [String: String] = ["Name": "", "Email": "", "Password": ""]
    let placeholderTexts = ["John Appleseed", "example@website.com", "Required"]
    let isSecures = [false, false, true]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = self.selectedAccountType.capitalizedString

        // Save Button
        let saveButton = UIBarButtonItem(title: "Save", style: UIBarButtonItemStyle.Done, target: self, action: "saveButtonPressed")
        self.navigationItem.rightBarButtonItem = saveButton
        
        
        // TableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.registerNib(UINib(nibName: "LMAccountDetailsCell", bundle: nil), forCellReuseIdentifier: kAccountDetailsCellId)
        
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return textFieldNames.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier(kAccountDetailsCellId) as! LMAccountDetailsCell
        let titleTexts = textFieldNames
        
        cell.setupWithTitle(titleTexts[indexPath.row], placeholderText: placeholderTexts[indexPath.row], isSecure: isSecures[indexPath.row])
        cell.delegate = self
        
        if indexPath.row == 0 {
            cell.textField.autocapitalizationType = UITextAutocapitalizationType.Words
            cell.textField.autocorrectionType = UITextAutocorrectionType.No
        } else if indexPath.row == 1 {
            cell.textField.keyboardType = UIKeyboardType.EmailAddress
            cell.textField.autocorrectionType = UITextAutocorrectionType.No
        }
        
        return cell
    }
    
    
    
    // Other Methods
    
    func accountDetailsCell(cell: LMAccountDetailsCell, didFinishedEditingWithTitle titleString: String, value: String) {
        self.textFieldDict[titleString] = value
    }
    
    
    func saveButtonPressed() {
        
        var textFieldValues: [String] = []
        for titleName in self.textFieldNames {
            let value = textFieldDict[titleName] as String!
            textFieldValues.append(value)
        }
        
        if textFieldValues.contains("") {
            let alertVC = UIAlertController(title: "Cannot Save", message: "Missing Some Fields", preferredStyle: UIAlertControllerStyle.Alert)
            alertVC.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alertVC, animated: true, completion: nil)
            return
        }
        
        saveAccountToCoreData(textFieldDict["Name"]!, email: textFieldDict["Email"]!, password: textFieldDict["Password"]!)        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    

    func saveAccountToCoreData(name: String, email: String, password: String) {
        
         LMCoreDataHelper.saveAccountToCoreData(name, email: email, password: password, selectedAccountType: selectedAccountType)
    }
    
    
}




