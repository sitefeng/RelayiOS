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
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.done, target: self, action: #selector(LMAddAccountViewController.cancelButtonPressed))
        self.navigationItem.leftBarButtonItem = cancelButton

        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = LMAddAccountCell.kCellHeight
        tableView.register(UINib(nibName: "LMAddAccountCell", bundle: nil), forCellReuseIdentifier: kAddAccountCellId)
        
    }

    
    
    // MARK: Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accountTypes.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: kAddAccountCellId) as! LMAddAccountCell
        
        cell.setupWithAccountType(type: accountTypes[indexPath.row])
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        let accountDetailsVC = LMAccountDetailsViewController(nibName:"LMAccountDetailsViewController", bundle: nil)
        accountDetailsVC.selectedAccountType = self.accountTypes[indexPath.row]
        
        self.navigationController?.pushViewController(accountDetailsVC, animated: true)
        
    }
    
    
    
    // Other methods
    func cancelButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
}







