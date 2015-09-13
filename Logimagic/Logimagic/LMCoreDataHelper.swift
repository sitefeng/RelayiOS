//
//  LMCoreDataHelper.swift
//  Logimagic
//
//  Created by Si Te Feng on 9/12/15.
//  Copyright (c) 2015 Si Te Feng. All rights reserved.
//

import UIKit
import CoreData

class LMCoreDataHelper: NSObject {
   
    class func removeAccountFromCoreData(account: LMAccount) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let moc = appDelegate.managedObjectContext
        
        var fetchRequest = NSFetchRequest(entityName: "Account")
        fetchRequest.predicate = NSPredicate(format: "email == %@ && type == %@", account.email, account.type)
        let accountsMOAny = moc?.executeFetchRequest(fetchRequest, error: nil)
        
        if accountsMOAny != nil {
            for accoutMOAny in accountsMOAny! {
                let accountMO = accoutMOAny as! NSManagedObject
                moc?.deleteObject(accountMO)
            }
            moc?.save(nil)
        }
    }
    
    
    class func saveAccountToCoreData(name: String, email: String, password: String, selectedAccountType: String) {
        
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let moc = appDelegate.managedObjectContext as NSManagedObjectContext!
        
        var accountDescription = NSEntityDescription.entityForName("Account", inManagedObjectContext: moc)
        var accountObject = NSManagedObject(entity: accountDescription!, insertIntoManagedObjectContext: moc)
        
        accountObject.setValue(name, forKey: "name")
        accountObject.setValue(selectedAccountType, forKey: "type")
        accountObject.setValue(email, forKey: "email")
        accountObject.setValue(password, forKey: "password")
        
        moc.save(nil)
    }
    
    class func getAllAccounts() -> [LMAccount] {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let moc = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Account")
        let accountsMO = moc?.executeFetchRequest(fetchRequest, error: nil)
        
        if accountsMO == nil {
            return []
        }
        
        var accounts: [LMAccount] = []
        for accountAny in accountsMO! {
            
            let accountMO = accountAny as! Account
            
            let account = LMAccount(_name: accountMO.name, _type: accountMO.type, _email: accountMO.email, _password: accountMO.password)
            accounts.append(account)
        }
        
        return accounts
    }
    
}


