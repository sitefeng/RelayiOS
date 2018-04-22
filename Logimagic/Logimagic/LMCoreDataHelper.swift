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
        let accountsMOAny = try? moc?.executeFetchRequest(fetchRequest)
        
        if accountsMOAny != nil {
            for accoutMOAny in accountsMOAny!! {
                let accountMO = accoutMOAny as! NSManagedObject
                moc?.deleteObject(accountMO)
            }
            do {
                try moc?.save()
            } catch _ {
            }
        }
    }
    
    
    class func saveAccountToCoreData(name: String, email: String, password: String, selectedAccountType: String) {
        
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let moc = appDelegate.managedObjectContext as NSManagedObjectContext!
        
        let accountDescription = NSEntityDescription.entityForName("Account", inManagedObjectContext: moc)
        let accountObject = NSManagedObject(entity: accountDescription!, insertIntoManagedObjectContext: moc)
        
        accountObject.setValue(name, forKey: "name")
        accountObject.setValue(selectedAccountType, forKey: "type")
        accountObject.setValue(email, forKey: "email")
        accountObject.setValue(password, forKey: "password")
        
        do {
            try moc.save()
        } catch _ {
        }
    }
    
    class func getAllAccounts() -> [LMAccount] {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let moc = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Account")
        let accountsMO = try? moc?.executeFetchRequest(fetchRequest)
        
        if accountsMO == nil {
            return []
        }
        
        var accounts: [LMAccount] = []
        for accountAny in accountsMO!! {
            
            let accountMO = accountAny as! Account
            
            let account = LMAccount(_name: accountMO.name, _type: accountMO.type, _email: accountMO.email, _password: accountMO.password)
            accounts.append(account)
        }
        
        return accounts
    }
    
}


