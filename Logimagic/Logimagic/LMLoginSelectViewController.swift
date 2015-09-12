//
//  LMLoginSelectViewController.swift
//  Logimagic
//
//  Created by Si Te Feng on 9/12/15.
//  Copyright (c) 2015 Si Te Feng. All rights reserved.
//

import UIKit
import LocalAuthentication

class LMLoginSelectViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let kLoginSelectCellId = "kLoginSelectCellId"
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var touchIdImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Navigation Bar
        var addButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        addButton.addTarget(self, action: "addButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
        addButton.setImage(UIImage(named: "addIcon"), forState: UIControlState.Normal)
        let addNavItem = UIBarButtonItem(customView: addButton)
        self.navigationItem.rightBarButtonItem = addNavItem
        
        // Touch ID
        touchIdImage.alpha = CGFloat(0)
        
        // TableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerNib(UINib(nibName: "LMLoginSelectCell", bundle: nil), forCellReuseIdentifier: kLoginSelectCellId)
        
    }

    
    func addButtonPressed() {
        let addAccountVC = LMAddAccountViewController(nibName:"LMAddAccountViewController", bundle: nil)
        
        self.presentViewController(addAccountVC, animated: true, completion: nil)
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var loginSelectCell = self.tableView.dequeueReusableCellWithIdentifier(kLoginSelectCellId) as! LMLoginSelectCell
        
        loginSelectCell.textLabel?.text = "Facebook"
        
        return loginSelectCell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.authenticateWithTouchId()
    }
    
    
    func authenticateWithTouchId() {
        
        let context = LAContext()
        if context.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, error: nil) {
            context.evaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, localizedReason: "Allow password to be sent to Chrome extension", reply: { (success, error) -> Void in
                if success {
                    
                    
                } else {
                    println("error:\(error.localizedDescription)")
                }
            })
            
            
            
        }
        
        
    }
    
    
    
    
    
    
    
}




