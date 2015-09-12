//
//  LMAccountDetailsViewController.swift
//  Logimagic
//
//  Created by Si Te Feng on 9/12/15.
//  Copyright (c) 2015 Si Te Feng. All rights reserved.
//

import UIKit

class LMAccountDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var selectedAccountType: String!
    
    @IBOutlet weak var tableView: UITableView!
    let kAccountDetailsCellId = "kAccountDetailsCellId"
    
    let titleTexts = ["Name", "Email", "Password"]
    let placeholderTexts = ["John Appleseed", "example@website.com", "Required"]
    let isSecures = [false, false, true]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerNib(UINib(nibName: "LMAccountDetailsCell", bundle: nil), forCellReuseIdentifier: kAccountDetailsCellId)
        
        
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleTexts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = self.tableView.dequeueReusableCellWithIdentifier(kAccountDetailsCellId) as! LMAccountDetailsCell
        
        cell.setupWithTitle(titleTexts[indexPath.row], placeholderText: placeholderTexts[indexPath.row], isSecure: isSecures[indexPath.row])
        
        return cell
    }
    
    
}
