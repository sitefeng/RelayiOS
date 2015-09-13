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
    
    var accounts: [LMAccount] = []
    var deviceIds: [String] = []
    
    var selectedIndexPath: NSIndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Service Login"
        
        // Navigation Bar
        var addButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        addButton.addTarget(self, action: "addButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
        addButton.setImage(UIImage(named: "addIcon"), forState: UIControlState.Normal)
        let addNavItem = UIBarButtonItem(customView: addButton)
        self.navigationItem.rightBarButtonItem = addNavItem
        
        // Touch ID
        touchIdImage.hidden = false
        
        // TableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = LMLoginSelectCell.kCellHeight
        tableView.registerNib(UINib(nibName: "LMLoginSelectCell", bundle: nil), forCellReuseIdentifier: kLoginSelectCellId)
        
        // Get all data
        self.deviceIds = [LMAuthContext().deviceId]
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.reloadData()
    }

    
    func addButtonPressed() {
        let addAccountVC = LMAddAccountViewController(nibName:"LMAddAccountViewController", bundle: nil)
        let addAccountNavController = UINavigationController(rootViewController: addAccountVC)
        self.presentViewController(addAccountNavController, animated: true, completion: nil)
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.accounts.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var loginSelectCell = self.tableView.dequeueReusableCellWithIdentifier(kLoginSelectCellId) as! LMLoginSelectCell
        let account = self.accounts[indexPath.row]
        
        loginSelectCell.setupCell(account.name, type: account.type, email: account.email)
        
        let backView = UIView(frame: CGRectZero)
        backView.backgroundColor = UIColor.blueColor().colorWithAlphaComponent(0.3)
        loginSelectCell.selectedBackgroundView = backView
        
        return loginSelectCell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedIndexPath = indexPath
        self.authenticateWithTouchId()
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            let account = self.accounts[indexPath.row]
            LMCoreDataHelper.removeAccountFromCoreData(account)
            
            self.reloadData()
        }
        
    }
    
    
    // Reloading
    
    func reloadData() {
        
        self.accounts = LMCoreDataHelper.getAllAccounts()
        self.tableView.reloadData()
    }
    
    
    
    func authenticateWithTouchId() {
        
        let context = LAContext()
        var evError: NSError?
        
        if context.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, error: &evError) {
            if evError != nil {
                println("auth Error: \(evError)")
                return
            }
            
            context.evaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, localizedReason: "Allow password to be sent to Chrome extension", reply: { (success, error) -> Void in
                if success {
                    println("success")
                    self.requestLogin()
                    
                    
                } else {
                    println("error:\(error.localizedDescription)")
                }
            })
        }
    }
    
    
    func requestLogin() {
        
        if selectedIndexPath != nil {
            let account = self.accounts[selectedIndexPath!.row]
            let deviceId = self.deviceIds[selectedIndexPath!.section]
            LMFirebaseInterfacer.sendLoginInfo(deviceId, serviceType: account.type, username: account.email, password: account.password)
            
            self.selectedIndexPath = nil;
            
        } else {
            println("No Row Selected")
        }
        
    }
    
    
}




