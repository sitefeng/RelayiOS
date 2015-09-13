//
//  LMAuthContext.swift
//  Logimagic
//
//  Created by Si Te Feng on 9/12/15.
//  Copyright (c) 2015 Si Te Feng. All rights reserved.
//

import UIKit

class LMAuthContext: NSObject {
   
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    let kDeviceIdKey = "kDeviceIdKey"

    var deviceId: String! {
        set {
            userDefaults.setObject(newValue, forKey: kDeviceIdKey)
            
        } get {
            return userDefaults.objectForKey(kDeviceIdKey) as! String
        }
    }
    
    
    override init() {
        super.init()
    }
    
    
    
}
