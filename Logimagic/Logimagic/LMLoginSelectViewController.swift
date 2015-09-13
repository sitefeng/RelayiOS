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
    let kDeviceCellId = "kDeviceCellId"
    

    @IBOutlet weak var serviceTableView: UITableView!
    @IBOutlet weak var deviceTableView: UITableView!
    
    var accounts: [LMAccount] = []
    var deviceIds: [String] = []
    var deviceNames: [String: String] = [String: String]() //deviceId: DeviceName
    
    var selectedServiceIndexPath: NSIndexPath?
    var selectedDeviceIndexPath: NSIndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Service Login"
        
        // Navigation Bar
        var addButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        addButton.addTarget(self, action: "addButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
        addButton.setImage(UIImage(named: "addIcon"), forState: UIControlState.Normal)
        let addNavItem = UIBarButtonItem(customView: addButton)
        self.navigationItem.rightBarButtonItem = addNavItem
        
        
        var addDevice = UIBarButtonItem(title: "New Device", style: UIBarButtonItemStyle.Plain, target: self, action: "addDevicePressed")
        self.navigationItem.leftBarButtonItem = addDevice
        
        
        // TableView
        serviceTableView.delegate = self
        serviceTableView.dataSource = self
        serviceTableView.rowHeight = LMLoginSelectCell.kCellHeight
        serviceTableView.registerNib(UINib(nibName: "LMLoginSelectCell", bundle: nil), forCellReuseIdentifier: kLoginSelectCellId)
        
        
        // Devices
        deviceTableView.delegate = self
        deviceTableView.dataSource = self
        deviceTableView.rowHeight = LMLoginSelectCell.kCellHeight
        deviceTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: kDeviceCellId)
        
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
    
    
    func addDevicePressed() {
        var qrVC = LMQRScanViewController(nibName: "LMQRScanViewController", bundle: nil)
        qrVC.isPopupPresented = true
        
        let navController = UINavigationController(rootViewController: qrVC)
        self.presentViewController(navController, animated: true, completion: nil)
        
    }
    
    // MARK: Table View
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        println("acc: \(accounts)")
        println("dev: \(deviceIds)")
        
        if serviceTableView == tableView {
            return self.accounts.count
        } else {
            return self.deviceNames.count
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let backView = UIView(frame: CGRectZero)
        backView.backgroundColor = UIColor.blueColor().colorWithAlphaComponent(0.3)
        
        if serviceTableView == tableView {
            var loginSelectCell = self.serviceTableView.dequeueReusableCellWithIdentifier(kLoginSelectCellId) as! LMLoginSelectCell
            let account = self.accounts[indexPath.row]
            
            loginSelectCell.setupCell(account.name, type: account.type, email: account.email)
            
            loginSelectCell.selectedBackgroundView = backView
            
            return loginSelectCell
        
        } else {
            
            var cell: UITableViewCell = self.deviceTableView.dequeueReusableCellWithIdentifier(kDeviceCellId, forIndexPath: indexPath) as! UITableViewCell
            
            let deviceId = self.deviceIds[indexPath.row]
            cell.textLabel?.text = self.deviceNames[deviceId]
            cell.selectedBackgroundView = backView
            return cell
        }
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if serviceTableView == tableView {
            if self.selectedDeviceIndexPath != nil {
            
                selectedServiceIndexPath = indexPath
                self.authenticateWithTouchId()
                self.serviceTableView.deselectRowAtIndexPath(indexPath, animated: true)
            } else {
                var alertVC = UIAlertController(title: "Cannot Login", message: "Please add new chrome extension connection via QR Scanner", preferredStyle: UIAlertControllerStyle.Alert)
                alertVC.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alertVC, animated: true, completion: nil)
            }
        } else {
            self.selectedDeviceIndexPath = indexPath
        }
        
    }
    
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle != UITableViewCellEditingStyle.Delete) {
            return
        }
        
        if serviceTableView == tableView {
            let account = self.accounts[indexPath.row]
            LMCoreDataHelper.removeAccountFromCoreData(account)
            
            
        } else {
            let deviceId = self.deviceIds[indexPath.row]
            LMAuthContext().removeDeviceId(deviceId)
            
        }
        
        self.reloadData()
        
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView == serviceTableView {
            return "Social Accounts"
        } else {
            return "Chrome Extension Devices"
        }
    }
    
    
    // Reloading
    
    func reloadData() {
        
        // Accounts
        self.accounts = LMCoreDataHelper.getAllAccounts()
        self.serviceTableView.reloadData()
        
        // Devices
        self.deviceIds = LMAuthContext().deviceIds
        self.deviceNames = [String: String]()
        
        for devId in self.deviceIds {
            LMFirebaseInterfacer.getDeviceNameStatic(devId, callback: { (deviceName) -> Void in
                
                self.deviceNames[devId] = deviceName
                self.deviceTableView.reloadData()
                
                // Select the first device by default
                if self.deviceTableView.numberOfRowsInSection(0) > 0 {
                    self.deviceTableView.selectRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), animated: false, scrollPosition: UITableViewScrollPosition.Top)
                    self.selectedDeviceIndexPath = NSIndexPath(forRow: 0, inSection: 0)
                }
            })
        }

        
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
        
        if selectedServiceIndexPath != nil && selectedDeviceIndexPath != nil {
            let account = self.accounts[selectedServiceIndexPath!.row]
            let deviceId = self.deviceIds[selectedDeviceIndexPath!.row]
            LMFirebaseInterfacer.sendLoginInfo(deviceId, serviceType: account.type, username: account.email, password: account.password)
            
            self.selectedServiceIndexPath = nil;
            
        } else {
            var alertVC = UIAlertController(title: "Cannot Login", message: "Please Select your Device and Social Account", preferredStyle: UIAlertControllerStyle.Alert)
            alertVC.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alertVC, animated: true, completion: nil)
        }
        
    }
    
    
}




