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
        let addNavItem = UIBarButtonItem(image: UIImage(named: "addIcon"), style: .plain, target: self, action: #selector(addButtonPressed(button:)))
        self.navigationItem.rightBarButtonItem = addNavItem
        
        
        let addDevice = UIBarButtonItem(title: "New Device", style: UIBarButtonItemStyle.plain, target: self, action: #selector(LMLoginSelectViewController.addDevicePressed))
        self.navigationItem.leftBarButtonItem = addDevice
        
        
        // TableView
        serviceTableView.delegate = self
        serviceTableView.dataSource = self
        serviceTableView.rowHeight = LMLoginSelectCell.kCellHeight
        serviceTableView.register(UINib(nibName: "LMLoginSelectCell", bundle: nil), forCellReuseIdentifier: kLoginSelectCellId)
        
        
        // Devices
        deviceTableView.delegate = self
        deviceTableView.dataSource = self
        deviceTableView.rowHeight = LMLoginSelectCell.kCellHeight
        deviceTableView.register(UITableViewCell.self, forCellReuseIdentifier: kDeviceCellId)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.reloadData()
        
    }

    
    func addButtonPressed(button: UIBarButtonItem) {
        let addAccountVC = LMAddAccountViewController(nibName:"LMAddAccountViewController", bundle: nil)
        let addAccountNavController = UINavigationController(rootViewController: addAccountVC)
        self.present(addAccountNavController, animated: true, completion: nil)
    }
    
    
    func addDevicePressed() {
        let qrVC = LMQRScanViewController(nibName: "LMQRScanViewController", bundle: nil)
        qrVC.isPopupPresented = true
        
        let navController = UINavigationController(rootViewController: qrVC)
        self.present(navController, animated: true, completion: nil)
        
    }
    
    // MARK: Table View
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("acc: \(accounts)")
        print("dev: \(deviceIds)")
        
        if serviceTableView == tableView {
            return self.accounts.count
        } else {
            return self.deviceNames.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let backView = UIView(frame: .zero)
        backView.backgroundColor = UIColor.blue.withAlphaComponent(0.3)
        
        if serviceTableView == tableView {
            let loginSelectCell = self.serviceTableView.dequeueReusableCell(withIdentifier: kLoginSelectCellId) as! LMLoginSelectCell
            let account = self.accounts[indexPath.row]
            
            loginSelectCell.setupCell(name: account.name, type: account.type, email: account.email)
            
            loginSelectCell.selectedBackgroundView = backView
            
            return loginSelectCell
        
        } else {
            
            let cell: UITableViewCell = self.deviceTableView.dequeueReusableCell(withIdentifier: kDeviceCellId, for: indexPath as IndexPath)
            
            let deviceId = self.deviceIds[indexPath.row]
            cell.textLabel?.text = self.deviceNames[deviceId]
            cell.selectedBackgroundView = backView
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if serviceTableView == tableView {
            if self.selectedDeviceIndexPath != nil {
            
                selectedServiceIndexPath = indexPath as NSIndexPath
//                self.authenticateWithTouchId()
                self.requestLogin()
                
                self.serviceTableView.deselectRow(at: indexPath as IndexPath, animated: true)
            } else {
                let alertVC = UIAlertController(title: "Cannot Login", message: "Please add new chrome extension connection via QR Scanner", preferredStyle: UIAlertControllerStyle.alert)
                alertVC.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
                self.present(alertVC, animated: true, completion: nil)
            }
        } else {
            self.selectedDeviceIndexPath = indexPath as NSIndexPath
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle != UITableViewCellEditingStyle.delete) {
            return
        }
        
        if serviceTableView == tableView {
            let account = self.accounts[indexPath.row]
            LMCoreDataHelper.removeAccountFromCoreData(account: account)
            
            
        } else {
            let deviceId = self.deviceIds[indexPath.row]
            LMAuthContext().removeDeviceId(deviceId: deviceId)
        }
        
        self.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
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
            LMFirebaseInterfacer.getDeviceNameStatic(deviceId: devId, callback: { (deviceName) -> Void in
                
                self.deviceNames[devId] = deviceName
                self.deviceTableView.reloadData()
                
                // Select the first device by default
                if self.deviceTableView.numberOfRows(inSection: 0) > 0 {
                    self.deviceTableView.selectRow(at: NSIndexPath(row: 0, section: 0) as IndexPath, animated: false, scrollPosition: UITableViewScrollPosition.top)
                    self.selectedDeviceIndexPath = NSIndexPath(row: 0, section: 0)
                }
            })
        }

        
    }
    
    
    func authenticateWithTouchId() {
        
        let context = LAContext()
        var evError: NSError?
        
        context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &evError)
        if evError != nil {
            print("auth Error: \(String(describing: evError))")
            return
        }
        
        context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Allow password to be sent to Chrome extension", reply: { (success, error) -> Void in
            if success {
                print("success")
                self.requestLogin()
                
                
            } else {
                print("error:\(error!.localizedDescription)")
            }
        })

    }
    
    
    func requestLogin() {
        
        if selectedServiceIndexPath != nil && selectedDeviceIndexPath != nil {
            let account = self.accounts[selectedServiceIndexPath!.row]
            let deviceId = self.deviceIds[selectedDeviceIndexPath!.row]
            LMFirebaseInterfacer.sendLoginInfo(deviceId: deviceId, serviceType: account.type, username: account.email, password: account.password)
            
            self.selectedServiceIndexPath = nil;
            
        } else {
            let alertVC = UIAlertController(title: "Cannot Login", message: "Please Select your Device and Social Account", preferredStyle: UIAlertControllerStyle.alert)
            alertVC.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertVC, animated: true, completion: nil)
        }
        
    }
    
    
}




