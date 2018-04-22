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
    
    let kDeviceIdsKey = "kDeviceIdsKey"

    
    var deviceIds: [String]! {
        set {
            userDefaults.setObject(newValue, forKey: kDeviceIdsKey)
            
        } get {
            return userDefaults.objectForKey(kDeviceIdsKey) as! [String]
        }
    }
    
    
    override init() {
        super.init()
        
        if userDefaults.objectForKey(kDeviceIdsKey) == nil {
            userDefaults.setObject([], forKey: kDeviceIdsKey)
        }

    }
    
    
    func addDeviceId(deviceId: String) {
        var idsArray = userDefaults.objectForKey(kDeviceIdsKey) as! [String]
        
        if !idsArray.contains(deviceId) {
            idsArray.append(deviceId)
            userDefaults.setObject(idsArray, forKey: kDeviceIdsKey)
        }
    }
    
    
    func removeDeviceId(deviceId: String) {
        let idsArray = userDefaults.objectForKey(kDeviceIdsKey) as! [String]
        
        let newArray = idsArray.filter({
            $0 != deviceId
        })

        userDefaults.setObject(newArray, forKey: kDeviceIdsKey)
    }
    
    
    
}
