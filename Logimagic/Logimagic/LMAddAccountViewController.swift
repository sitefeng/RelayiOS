//
//  LMAddAccountViewController.swift
//  Logimagic
//
//  Created by Si Te Feng on 9/12/15.
//  Copyright (c) 2015 Si Te Feng. All rights reserved.
//

import UIKit

class LMAddAccountViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    let kAddAccountCellId = "kAddAccountCellId"
    
    let accountTypes = ["facebook", "linkedin", "gmail", "twitter"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Add Account"
        
        // Cancel Button
        var cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Done, target: self, action: "cancelButtonPressed")
        self.navigationItem.rightBarButtonItem = cancelButton

        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = LMAddAccountCell.kCellHeight
        tableView.registerNib(UINib(nibName: "LMAddAccountCell", bundle: nil), forCellReuseIdentifier: kAddAccountCellId)
        
    }

    
    
    // MARK: Table View
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accountTypes.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = self.tableView.dequeueReusableCellWithIdentifier(kAddAccountCellId) as! LMAddAccountCell
        
        cell.setupWithAccountType(accountTypes[indexPath.row])
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let accountDetailsVC = LMAccountDetailsViewController(nibName:"LMAccountDetailsViewController", bundle: nil)
        accountDetailsVC.selectedAccountType = self.accountTypes[indexPath.row]
        
        self.navigationController?.pushViewController(accountDetailsVC, animated: true)
        
    }
    
    
    
    // Other methods
    func cancelButtonPressed() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}







