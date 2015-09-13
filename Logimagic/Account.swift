//
//  Account.swift
//  
//
//  Created by Si Te Feng on 9/12/15.
//
//

import Foundation
import CoreData

class Account: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var email: String
    @NSManaged var password: String
    @NSManaged var type: String

}
